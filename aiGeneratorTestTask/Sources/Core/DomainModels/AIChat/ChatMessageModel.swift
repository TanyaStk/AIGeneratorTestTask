//
//  ChatMessageModel.swift
//  aiGeneratorTestTask
//

import Foundation

struct ChatMessageModel: Identifiable, Equatable, Hashable {
    let id: UUID
    let content: String
    let role: MessageRole
    let createdAt: Date

    init(content: String, role: MessageRole, createdAt: Date = Date()) {
        self.id        = UUID()
        self.content   = content
        self.role      = role
        self.createdAt = createdAt
    }
}
