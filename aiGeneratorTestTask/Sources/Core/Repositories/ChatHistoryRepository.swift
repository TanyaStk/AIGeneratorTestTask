//
//  ChatHistoryRepository.swift
//  aiGeneratorTestTask
//
//

import CoreData

final class ChatHistoryRepository {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.context) {
        self.context = context
    }
    
    @discardableResult
    func createSession(title: String = "New Chat") throws -> ChatSessionEntity {
        let session = ChatSessionEntity(context: context)
        session.id = UUID()
        session.title = title
        session.createdAt = Date()
        try context.save()
        
        return session
    }
    
    func fetchAllSessions() throws -> [ChatSessionEntity] {
        let request = NSFetchRequest<ChatSessionEntity>(entityName: "ChatSessionEntity")
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        return try context.fetch(request)
    }
    
    @discardableResult
    func addMessage(
        content: String,
        role: MessageRole,
        to session: ChatSessionEntity
    ) throws -> ChatMessageEntity {
        let msg = ChatMessageEntity(context: context)
        msg.id = UUID()
        msg.content = content
        msg.role = role.rawValue
        msg.createdAt = Date()
        msg.session = session
        
        let mutable = session.messages.mutableCopy() as! NSMutableOrderedSet
        mutable.add(msg)
        session.messages = mutable
        
        if role == .user && session.title == "New Chat" {
            session.title = String(content.prefix(40))
        }
        
        try context.save()
        return msg
    }
}
