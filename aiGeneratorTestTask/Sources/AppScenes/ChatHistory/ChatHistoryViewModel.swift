//
//  ChatHistoryViewModel.swift
//  aiGeneratorTestTask
//

import Foundation
import Combine

@MainActor
final class ChatHistoryViewModel: ObservableObject {
    
    @Injected(\.chatHistoryService) private var service

    @Published private(set) var state = State()
    
    func load() async {
        state.isLoading = true
        state.errorMessage = nil
        
        defer { state.isLoading = false }
        
        do {
            state.chats = try await service.fetchChats()
        } catch {
            state.errorMessage = error.userFacingMessage
        }
    }
    
    func dismissError() {
        state.errorMessage = nil
    }
}

extension ChatHistoryViewModel {
    struct State {
        var chats: [ChatSummaryModel] = []
        var isLoading = false
        var errorMessage: String?
    }
}
