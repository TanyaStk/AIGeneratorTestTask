//
//  VideoGenerationError.swift
//  aiGeneratorTestTask
//

import Foundation

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
