//
//  ChatServiceProtocol.swift
//  aiGeneratorTestTask
//
//

import Foundation
import SwiftUI

protocol ChatServiceProvider {
    func send(message: String, chatId: String) async throws -> String
}

final class ChatAPIService: ChatServiceProvider {
    
    @AppStorage("userID")
    private var userID: String = ""
    
    private let network: NetworkServiceType

    init(network: NetworkServiceType) {
        self.network = network
    }

    func send(message: String, chatId: String) async throws -> String {
        let body = SendMessageRequest(message: message)

        let response: SendMessageResponse = try await network.post(
            path: APIConstants.Paths.chatMessages(chatId: chatId),
            queryItems: [
                URLQueryItem(name: "chat_id", value: chatId),
                URLQueryItem(name: "user_id", value: userID),
                URLQueryItem(name: "app_id",  value: APIConstants.appId)
            ],
            body: body
        )
        return response.assistantMessage
    }
}

// MARK: - Mock

struct MockChatService: ChatServiceProvider {
    static let defaultResponse = """
**Welcome to the team, Alexander!**

Hi Alexander, welcome to the development team! We're all really looking forward to having you start next week.

Here are a few tips:
- **Focus on getting up to speed** — don't hesitate to ask questions.
- **Meet the team** — short welcome meeting on Monday at 11:00 AM.
- **Documentation** — all key materials are in our internal knowledge base.
"""

    func send(message: String, chatId: String) async throws -> String {
        try await Task.sleep(nanoseconds: 4_000_000_000)
        
        return Self.defaultResponse
    }
}
