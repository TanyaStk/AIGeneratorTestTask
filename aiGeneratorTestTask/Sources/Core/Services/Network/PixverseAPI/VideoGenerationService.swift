//
//  VideoGenerationService.swift
//  aiGeneratorTestTask
//

import UIKit
import SwiftUI

protocol VideoGenerationService {
    func generate(request: VideoGenerationRequest) async throws -> VideoGenerationResponse
}

final class VideoGenerationAPIService: VideoGenerationService {
    
    @AppStorage("userID")
    private var userID: String = ""
    
    private let network: NetworkServiceType

    init(network: NetworkServiceType) {
        self.network = network
    }

    func generate(request: VideoGenerationRequest) async throws -> VideoGenerationResponse {
        let videoId = try await submitGeneration(request: request)
        let videoURL = try await pollStatus(videoId: videoId)

        return VideoGenerationResponse(
            id: videoId,
            templateTitle: request.templateTitle,
            videoURL: videoURL
        )
    }
}

private extension VideoGenerationAPIService {
    
    func submitGeneration(request: VideoGenerationRequest) async throws -> Int {
        guard let image = request.image,
              let imageData = image.jpegData(compressionQuality: 0.85) else {
            throw VideoGenerationError.unknown
        }

        let body = VideoGenerationAPIRequest(
            userId: userID,
            appId: APIConstants.appId,
            templateId: request.templateId,
            image: imageData.base64EncodedString(),
            duration: request.duration,
            quality: request.quality
        )

        let response: VideoGenerationAPIResponse = try await network.post(
            path: APIConstants.Paths.generateVideo,
            body: body
        )
        return response.videoId
    }

    func pollStatus(videoId: Int) async throws -> URL? {
        for attempt in 1...Constants.maxPollAttempts {
            try Task.checkCancellation()

            let status: VideoStatusResponse = try await network.get(
                path: APIConstants.Paths.videoStatus,
                queryItems: [
                    URLQueryItem(name: "id", value: "\(videoId)"),
                    URLQueryItem(name: "user_id", value: userID),
                    URLQueryItem(name: "app_id", value: APIConstants.appId)
                ]
            )

            switch VideoStatus(status.status) {
            case .completed:
                return status.videoUrl.flatMap(URL.init)

            case .failed:
                throw VideoGenerationError.serverError(code: -1)

            case .pending, .processing, .unknown:
                if attempt == Constants.maxPollAttempts {
                    throw VideoGenerationError.timeout
                }
                try await Task.sleep(nanoseconds: Constants.pollInterval)
            }
        }
        
        throw VideoGenerationError.timeout
    }
}

private extension VideoGenerationAPIService {
    enum Constants {
        static let pollInterval: UInt64 = 3_000_000_000
        static let maxPollAttempts: Int = 40
    }
}

// MARK: - MockVideoGenerationService

struct MockVideoGenerationService: VideoGenerationService {
    var successRate: Double = 0.75

    func generate(request: VideoGenerationRequest) async throws -> VideoGenerationResponse {
        try await Task.sleep(nanoseconds: UInt64.random(in: 3_000_000_000...5_000_000_000))
        
        guard Double.random(in: 0...1) <= successRate else {
            throw [VideoGenerationError.networkFailure,
                   VideoGenerationError.serverError(code: 500),
                   VideoGenerationError.timeout].randomElement()!
        }
        
        return VideoGenerationResponse(
            id: Int.random(in: 1000...9999),
            templateTitle: request.templateTitle,
            videoURL: URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_4x3/bipbop_4x3_variant.m3u8")
        )
    }
}
