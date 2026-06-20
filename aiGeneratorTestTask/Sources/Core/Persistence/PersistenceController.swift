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
        
        model.entities = [videoEntity]
        
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
