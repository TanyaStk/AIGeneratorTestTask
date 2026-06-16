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
        case history(type: HistoryType)
    }
    
    enum HistoryType {
        case chat
        case video
    }
}
