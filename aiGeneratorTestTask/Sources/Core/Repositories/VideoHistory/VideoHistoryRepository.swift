//
//  VideoHistoryRepository.swift
//  aiGeneratorTestTask
//
//

import CoreData

protocol VideoHistoryRepositoryProtocol {
    func save(videoFileName: String, thumbnailFileName: String?) throws -> VideoHistoryItemModel
    func fetchAll() throws -> [VideoHistoryItemModel]
}

final class VideoHistoryRepository: VideoHistoryRepositoryProtocol {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.context) {
        self.context = context
    }
    
    @discardableResult
    func save(
        videoFileName: String,
        thumbnailFileName: String?
    ) throws -> VideoHistoryItemModel {
        let item = VideoHistoryEntity(context: context)
        item.id = UUID()
        item.videoFilePath = videoFileName
        item.thumbnailPath = thumbnailFileName
        
        try context.save()
        
        return .init(
            id: item.id,
            videoFilePath: videoFileName,
            thumbnailPath: thumbnailFileName
        )
    }
    
    func fetchAll() throws -> [VideoHistoryItemModel] {
        let request = NSFetchRequest<VideoHistoryEntity>(entityName: "VideoHistoryEntity")
        
        return try context.fetch(request).map { entity in
            VideoHistoryItemModel(id: entity.id, videoFilePath: entity.videoFilePath, thumbnailPath: entity.thumbnailPath)
        }
    }
}
