//
//  AppRouter+Destination.swift
//  aiGeneratorTestTask
//

import Foundation

extension AppRouter {
    
    enum Destination: Hashable {
        case settings
        case photoToVideoGeneration
        case aiChat
        case templateDetail(selected: VideoTemplate, all: [VideoTemplate])
        case videoProcess(request: VideoGenerationRequest)
        case videoHistory
        case chatHistory
    }
}
