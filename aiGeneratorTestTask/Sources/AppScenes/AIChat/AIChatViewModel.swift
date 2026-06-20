//
//  AIChatViewModel.swift
//  aiGeneratorTestTask
//

import Foundation
import Combine

@MainActor
final class AIChatViewModel: ObservableObject {
    
    @Injected(\.chatService) private var chatService
    @Injected(\.chatHistoryService) private var historyService

    @Published var state = State()

    private var chatId: String?

    func send() {
        let text = state.inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !text.isEmpty, !state.isSending else { return }

        if chatId == nil {
            chatId = UUID().uuidString
        }
        
        guard let chatId else { return }

        state.inputText  = ""
        state.hasStarted = true

        let userMessage = ChatMessageModel(content: text, role: .user)
        state.messages.append(userMessage)
        state.isSending = true

        Task {
            defer { state.isSending = false }
            
            do {
                let response = try await chatService.send(message: text, chatId: chatId)
                state.messages.append(ChatMessageModel(content: response, role: .ai))
            } catch {
                state.errorMessage = error.localizedDescription
            }
        }
    }
}

extension AIChatViewModel {
    struct State {
        var messages: [ChatMessageModel] = []
        var inputText: String = ""
        var isSending: Bool = false
        var isLoading: Bool = false
        var hasStarted: Bool = false
        var errorMessage: String?

        var inputPlaceholder: String {
            hasStarted ? "How can I help you?" : "Ask anything..."
        }

        var showSendButton: Bool {
            !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }
}
