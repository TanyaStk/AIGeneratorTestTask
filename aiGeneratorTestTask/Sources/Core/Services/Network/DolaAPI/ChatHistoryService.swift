//
//  ChatHistoryServiceProvider.swift
//  aiGeneratorTestTask
//

import Foundation
import SwiftUI

protocol ChatHistoryServiceProvider {
    func fetchChats() async throws -> [ChatSummaryModel]
    func fetchMessages(chatId: String, limit: Int?, offset: Int) async throws -> [ChatMessageModel]
}

final class ChatHistoryService: ChatHistoryServiceProvider {
    
    private let network: NetworkServiceType
    
    @AppStorage("userID")
    private var userID: String = ""

    init(network: NetworkServiceType) {
        self.network = network
    }

    func fetchChats() async throws -> [ChatSummaryModel] {
        let dtos: [ChatSummaryDTO] = try await network.get(
            path: APIConstants.Paths.chatsList,
            queryItems: [
                URLQueryItem(name: "user_id", value: userID),
                URLQueryItem(name: "app_id",  value: APIConstants.appId)
            ]
        )
        
        
        
        return dtos
            .map { $0.toModel() }
            .sorted { $0.updatedAt > $1.updatedAt }
    }
}

// MARK: - Mock

struct MockChatHistoryService: ChatHistoryServiceProvider {
    func fetchChats() async throws -> [ChatSummaryModel] {
        try await Task.sleep(nanoseconds: 1000_000_000)
        
        return [
            ChatSummaryModel(chatId: "1", title: "Welcome email for Alexander", updatedAt: Date(), lastMessagePreview: "Welcome to the team, Alexander!"),
            ChatSummaryModel(chatId: "2", title: "Trip itinerary", updatedAt: Date().addingTimeInterval(-86400), lastMessagePreview: "Here's a 3-day plan for Lisbon..."),
            ChatSummaryModel(chatId: "3", title: "Welcome email for Alexander", updatedAt: Date(), lastMessagePreview: "Welcome to the team, Alexander!"),
            ChatSummaryModel(chatId: "4", title: "Trip itinerary", updatedAt: Date().addingTimeInterval(-86400), lastMessagePreview: "Here's a 3-day plan for Lisbon..."),
            ChatSummaryModel(chatId: "5", title: "Welcome email for Alexander", updatedAt: Date(), lastMessagePreview: "Welcome to the team, Alexander!"),
            ChatSummaryModel(chatId: "6", title: "Trip itinerary", updatedAt: Date().addingTimeInterval(-86400), lastMessagePreview: "Here's a 3-day plan for Lisbon..."),
            ChatSummaryModel(chatId: "7", title: "Welcome email for Alexander", updatedAt: Date(), lastMessagePreview: "Welcome to the team, Alexander!"),
            ChatSummaryModel(chatId: "8", title: "Trip itinerary", updatedAt: Date().addingTimeInterval(-86400), lastMessagePreview: "Here's a 3-day plan for Lisbon...")
        ]
    }
}
