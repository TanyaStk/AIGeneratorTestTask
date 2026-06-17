//
//  PersistenceController.swift
//  aiGeneratorTestTask
//

import CoreData

final class PersistenceController {
    
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    var context: NSManagedObjectContext { container.viewContext }

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(
            name: "AIToolsModel",
            managedObjectModel: Self.makeModel()
        )
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { _, error in
            if let error { fatalError("CoreData load failed: \(error)") }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    private static func makeModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()

        // MARK: - VideoHistoryEntity
        let videoEntity = entity(
            name: "VideoHistoryEntity",
            className: VideoHistoryEntity.self,
            attributes: [
                attribute("id",              .UUIDAttributeType),
                attribute("videoFilePath",   .stringAttributeType),
                attribute("thumbnailPath",   .stringAttributeType, optional: true),
            ]
        )

        // MARK: - ChatSessionEntity
        let sessionEntity = entity(
            name: "ChatSessionEntity",
            className: ChatSessionEntity.self,
            attributes: [
                attribute("id",        .UUIDAttributeType),
                attribute("title",     .stringAttributeType),
                attribute("createdAt", .dateAttributeType)
            ]
        )

        // MARK: - ChatMessageEntity
        let messageEntity = entity(
            name: "ChatMessageEntity",
            className: ChatMessageEntity.self,
            attributes: [
                attribute("id",        .UUIDAttributeType),
                attribute("content",   .stringAttributeType),
                attribute("role",      .stringAttributeType),
                attribute("createdAt", .dateAttributeType)
            ]
        )

        // MARK: - Relationships
        let sessionToMessages = relationship(
            name: "messages",
            destination: messageEntity,
            toMany: true,
            deleteRule: .cascadeDeleteRule,
            ordered: true
        )
        let messageToSession = relationship(
            name: "session",
            destination: sessionEntity,
            toMany: false,
            deleteRule: .nullifyDeleteRule
        )
        sessionToMessages.inverseRelationship = messageToSession
        messageToSession.inverseRelationship = sessionToMessages

        sessionEntity.properties.append(sessionToMessages)
        messageEntity.properties.append(messageToSession)

        model.entities = [videoEntity, sessionEntity, messageEntity]
        return model
    }
}

// MARK: - Builder helpers

private extension PersistenceController {
    static func entity<T: NSManagedObject>(
        name: String,
        className: T.Type,
        attributes: [NSAttributeDescription]
    ) -> NSEntityDescription {
        let e = NSEntityDescription()
        e.name = name
        e.managedObjectClassName = NSStringFromClass(className)
        e.properties = attributes
        
        return e
    }

    static func attribute(
        _ name: String,
        _ type: NSAttributeType,
        optional: Bool = false
    ) -> NSAttributeDescription {
        let a = NSAttributeDescription()
        a.name = name
        a.attributeType = type
        a.isOptional = optional
        
        return a
    }

    static func relationship(
        name: String,
        destination: NSEntityDescription,
        toMany: Bool,
        deleteRule: NSDeleteRule,
        ordered: Bool = false
    ) -> NSRelationshipDescription {
        let r = NSRelationshipDescription()
        r.name = name
        r.destinationEntity = destination
        r.minCount = 0
        r.maxCount = toMany ? 0 : 1
        r.deleteRule = deleteRule
        r.isOrdered = ordered
        
        return r
    }
}
