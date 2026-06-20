//
//  Error+userFacing.swift
//  aiGeneratorTestTask
//

import Foundation

extension Error {
    var userFacingMessage: String {
        if let apiError = self as? APIError {
            return apiError.errorDescription ?? "Something went wrong."
        }
        
        if let urlError = self as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                return "No internet connection. Please check your network and try again."
            case .timedOut:
                return "The request timed out. Please try again."
            default:
                return "Something went wrong. Please try again."
            }
        }
        
        return "Something went wrong. Please try again."
    }
}
