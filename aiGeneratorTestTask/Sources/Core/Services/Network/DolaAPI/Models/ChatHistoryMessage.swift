//
//  ChatHistoryMessageDTO.swift
//  aiGeneratorTestTask
//

import Foundation

struct ChatHistoryMessageDTO: Decodable {
    let role: String
    let content: String
    let messageSource: String
    let createdAt: Date
}

extension ChatHistoryMessageDTO {
    func toModel() -> ChatMessageModel {
        ChatMessageModel(
            content: content,
            role: MessageRole(apiRole: role),
            createdAt: createdAt
        )
    }
}
