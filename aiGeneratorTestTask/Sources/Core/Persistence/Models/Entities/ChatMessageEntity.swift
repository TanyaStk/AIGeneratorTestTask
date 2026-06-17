//
//  ChatMessageEntity.swift
//  aiGeneratorTestTask
//
//

import CoreData

enum MessageRole: String {
    case user = "user"
    case ai   = "ai"
}

@objc(ChatMessageEntity)
final class ChatMessageEntity: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var content: String
    @NSManaged public var role: String       // "user" | "ai"
    @NSManaged public var createdAt: Date
    @NSManaged public var session: ChatSessionEntity?

    var messageRole: MessageRole {
        get { MessageRole(rawValue: role) ?? .user }
        set { role = newValue.rawValue }
    }
}
