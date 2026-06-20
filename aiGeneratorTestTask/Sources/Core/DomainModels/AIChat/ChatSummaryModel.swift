//
//  ChatSummaryModel.swift
//  aiGeneratorTestTask
//

import Foundation

struct ChatSummaryModel: Identifiable, Hashable {
    var id: String { chatId }
    let chatId: String
    let title: String
    let updatedAt: Date
    let lastMessagePreview: String
}
