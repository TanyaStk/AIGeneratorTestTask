//
//  VideoGenerationAPIRequest.swift
//  aiGeneratorTestTask
//

import Foundation

struct VideoGenerationAPIRequest: Encodable {
    let userId: String
    let appId: String
    let prompt: String
    let image: String
    let duration: Int
    let quality: String
}

struct VideoGenerationAPIResponse: Decodable {
    let videoId: Int
    let detail: String
}
