//
//  VideoGenerationResult.swift
//  aiGeneratorTestTask
//

import Foundation

struct VideoGenerationResult: Hashable {
    let id = UUID()
    let templateTitle: String
    let videoURL: URL
}
