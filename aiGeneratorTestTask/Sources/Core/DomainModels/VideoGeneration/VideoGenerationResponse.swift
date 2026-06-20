//
//  VideoGenerationResponse.swift
//  aiGeneratorTestTask
//

import Foundation

struct VideoGenerationResponse: Hashable {
    let id: Int // returned by API
    let templateTitle: String
    
    var videoURL: URL?          // populated after polling
}
