//
//  VideoGenerationResponse.swift
//  aiGeneratorTestTask
//

import Foundation

struct VideoGenerationResponse: Hashable {
    let id: Int // returned by API
    let templateTitle: String
    let videoURL: URL?          // populated after polling
}
