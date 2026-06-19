//
//  ChatSummaryDTO.swift
//  aiGeneratorTestTask
//

import Foundation

// MARK: - GET /dola/chats

struct ChatSummaryDTO: Decodable {
    let chatId: String
    let title: String
    let personaId: Int?
    let updatedAt: Date
    let lastMessagePreview: String
}

extension ChatSummaryDTO {
    func toModel() -> ChatSummaryModel {
        ChatSummaryModel(
            chatId: chatId,
            title: title,
            updatedAt: updatedAt,
            lastMessagePreview: lastMessagePreview
        )
    }
}
