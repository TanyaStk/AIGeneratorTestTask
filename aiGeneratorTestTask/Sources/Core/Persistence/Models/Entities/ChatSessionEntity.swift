//
//  ChatSessionEntity.swift
//  aiGeneratorTestTask
//
//

import CoreData

@objc(ChatSessionEntity)
final class ChatSessionEntity: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var createdAt: Date
    @NSManaged public var messages: NSOrderedSet
    
    var sortedMessages: [ChatMessageEntity] {
        (messages.array as? [ChatMessageEntity] ?? [])
            .sorted { $0.createdAt < $1.createdAt }
    }
    
    var lastMessage: ChatMessageEntity? {
        sortedMessages.last
    }
}
