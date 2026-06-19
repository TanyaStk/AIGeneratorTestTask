//
//  MessageBubble.swift
//  aiGeneratorTestTask
//

import SwiftUI

struct MessageBubble: View {
    
    let message: ChatMessageModel

    private var isUser: Bool { message.role == .user }

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            if isUser {
                Spacer()
                bubble
            } else {
                bubble
                Spacer()
            }
        }
    }

    @ViewBuilder
    private var bubble: some View {
        if isUser {
            Text(message.content)
                .font(.system(size: 14))
                .foregroundStyle(.white)
                .padding(16)
                .background(BluePinkGradientStyle())
                .clipShape(ChatBubbleShape(tailSide: .right))
        } else {
            Text(attributedContent)
                .font(.system(size: 14))
                .foregroundStyle(.accent.opacity(0.9))
                .padding(16)
                .background(Color.card.opacity(0.6))
                .clipShape(ChatBubbleShape(tailSide: .left))
        }
    }

    private var attributedContent: AttributedString {
        (try? AttributedString(
            markdown: message.content,
            options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)
        )) ?? AttributedString(message.content)
    }
}

#Preview {
    VStack(spacing: 16) {
        MessageBubble(message: ChatMessageModel(
            content: "Hi! Can you help me write a short welcome email for a new employee joining our team?",
            role: .user
        ))
        MessageBubble(message: ChatMessageModel(
            content: MockChatService.defaultResponse,
            role: .ai
        ))
    }
}
