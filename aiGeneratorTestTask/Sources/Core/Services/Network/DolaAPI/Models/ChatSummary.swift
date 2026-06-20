//
//  ChatSummaryDTO.swift
//  aiGeneratorTestTask
//

import Foundation

struct ChatSummaryDTO: Decodable {
    let chatId: String
    let title: String?
    let personaId: Int?
    let updatedAt: Date
    let lastMessagePreview: String
}

extension ChatSummaryDTO {
    func toModel() -> ChatSummaryModel {
        ChatSummaryModel(
            chatId: chatId,
            title: title ?? lastMessagePreview,
            updatedAt: updatedAt,
            lastMessagePreview: lastMessagePreview
        )
    }
}
