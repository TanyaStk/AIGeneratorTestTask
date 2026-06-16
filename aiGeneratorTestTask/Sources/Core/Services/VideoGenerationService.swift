//
//  VideoGenerationService.swift
//  aiGeneratorTestTask
//

import Foundation

protocol VideoGenerationService {
    func generate(request: VideoGenerationRequest) async throws -> VideoGenerationResult
}

enum VideoGenerationError: LocalizedError, Hashable {
    case networkFailure
    case serverError(code: Int)
    case timeout
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .networkFailure: 
            "No internet connection. Please try again."
        case .serverError(let code): 
            "Server returned an error (\(code)). Try again later."
        case .timeout: 
            "Generation took too long. Please try again."
        case .unknown: 
            "Something went wrong. Please try again."
        }
    }
}

struct MockVideoGenerationService: VideoGenerationService {
    
    var successRate: Double = 0.75
    
    func generate(request: VideoGenerationRequest) async throws -> VideoGenerationResult {
        let delay = UInt64.random(in: 3_000_000_000...5_000_000_000)
        try await Task.sleep(nanoseconds: delay)
        
        if Double.random(in: 0...1) <= successRate {
            return VideoGenerationResult(
                templateTitle: request.templateTitle,
                videoURL: "https://mock.example.com/video/\(request.templateId).mp4"
            )
        } else {
            let errors: [VideoGenerationError] = [
                .networkFailure,
                .serverError(code: 500),
                .timeout,
                .unknown
            ]
            
            throw errors.randomElement()!
        }
    }
}
