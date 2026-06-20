//
//  MessageRole.swift
//  aiGeneratorTestTask
//

import Foundation

enum MessageRole: String {
    case user
    case ai

    init(apiRole: String) {
        switch apiRole.lowercased() {
        case "user": self = .user
        default:     self = .ai   // "assistant", "ai", "bot", etc.
        }
    }
}
