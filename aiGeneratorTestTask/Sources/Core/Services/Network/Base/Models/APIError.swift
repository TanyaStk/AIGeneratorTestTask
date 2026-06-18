//
//  APIError.swift
//  aiGeneratorTestTask
//
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse(statusCode: Int)
    case decodingFailed(underlying: Error)
    case validationError(details: [ValidationDetail])
    case unknown(underlying: Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .invalidResponse(let code):
            return "Server returned status code \(code)."
        case .decodingFailed:
            return "Failed to parse server response."
        case .validationError(let details):
            return details.first?.msg ?? "Validation error."
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
