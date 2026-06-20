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
    
    private let network: NetworkServiceType
    private let userSession: UserSessionProvider
    
    init(network: NetworkServiceType,
         userSession: UserSessionProvider) {
        self.network = network
        self.userSession = userSession
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
        
        let file = MultipartFile(
            name: "image",
            filename: "photo.jpg",
            mimeType: "image/jpeg",
            data: imageData
        )
        
        let textFields: [String: String] = [
            "prompt": "generate video with \(request.templateTitle)",
            "duration": "\(request.duration)",
            "quality": request.quality
        ]
        
        let response: VideoGenerationAPIResponse = try await network.postMultipart(
            path: APIConstants.Paths.generateVideo,
            queryItems: [
                URLQueryItem(name: "user_id", value: userSession.userID),
                URLQueryItem(name: "app_id",  value: APIConstants.appId)
            ],
            textFields: textFields,
            file: file
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
                    URLQueryItem(name: "user_id", value: userSession.userID),
                    URLQueryItem(name: "app_id", value: APIConstants.appId)
                ]
            )
            
            switch VideoStatus(status.status) {
            case .completed:
                if let videoUrl = status.videoUrl.flatMap(URL.init) {

                    //                    let videoUrl = URL(string: Self.getRandomVideoURL())! // TODO: - remove mock url in production
                    
                    return try await network.download(from: videoUrl)
                }
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

// MARK: - Mock video urls

private extension VideoGenerationAPIService {
    static func getRandomVideoURL() -> String {
        [
            "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/360/Big_Buck_Bunny_360_10s_1MB.mp4",
            "https://test-videos.co.uk/vids/sintel/mp4/h264/720/Sintel_720_10s_2MB.mp4",
            "https://test-videos.co.uk/vids/jellyfish/mp4/h264/360/Jellyfish_360_10s_1MB.mp4"
        ].randomElement() ?? ""
    }
}

// MARK: - Constants

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
            videoURL: URL(string: "https://example.com/sandbox/pixverse/sample.mp4")
        )
    }
}
