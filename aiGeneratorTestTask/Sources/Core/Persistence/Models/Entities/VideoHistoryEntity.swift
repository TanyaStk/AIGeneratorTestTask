//
//  VideoHistoryEntity.swift
//  aiGeneratorTestTask
//
//

import CoreData

@objc(VideoHistoryEntity)
public final class VideoHistoryEntity: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var videoFilePath: String   // relative filename in Documents/Videos/
    @NSManaged public var thumbnailPath: String?  // relative filename in Documents/Thumbnails/
}
