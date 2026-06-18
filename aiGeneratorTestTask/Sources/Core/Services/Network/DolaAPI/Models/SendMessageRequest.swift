//
//  SendMessageRequest.swift
//  aiGeneratorTestTask
//
//

import Foundation

struct SendMessageRequest: Encodable {
    let message: String
    let personaId: String?      = nil
    let additionalPrompt: String? = nil
}

struct SendMessageResponse: Decodable {
    let chatId: String
    let assistantMessage: String
}
