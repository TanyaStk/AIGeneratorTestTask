//
//  VideoStatusResponse.swift
//  aiGeneratorTestTask
//

import Foundation

struct VideoStatusResponse: Decodable {
    let status: String
    let videoUrl: String?
}

enum VideoStatus: String {
    case pending = "pending"
    case processing = "processing"
    case completed = "completed"
    case failed = "failed"
    case unknown

    init(_ raw: String) {
        self = VideoStatus(rawValue: raw.lowercased()) ?? .unknown
    }

    var isTerminal: Bool {
        self == .completed || self == .failed
    }
}
