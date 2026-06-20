//
//  MockVideoHistoryRepository.swift
//  aiGeneratorTestTask
//


import Foundation

final class MockVideoHistoryRepository: VideoHistoryRepositoryProtocol {
    
    private var items: [VideoHistoryItemModel]

    init(items: [VideoHistoryItemModel] = VideoHistoryItemModel.previews) {
        self.items = items
    }

    func save(videoFileName: String, thumbnailFileName: String?) throws -> VideoHistoryItemModel {
        let item = VideoHistoryItemModel(
            id: UUID(),
            videoFilePath: videoFileName,
            thumbnailPath: thumbnailFileName
        )
        items.insert(item, at: 0)
        
        return item
    }

    func fetchAll() throws -> [VideoHistoryItemModel] { [] }
}

private extension VideoHistoryItemModel {
    static let previews: [VideoHistoryItemModel] = [
        VideoHistoryItemModel(
            id: UUID(),
            videoFilePath: "mock1.mp4",
            thumbnailPath: "card1.png"
        ),
        VideoHistoryItemModel(
            id: UUID(),
            videoFilePath: "mock2.mp4",
            thumbnailPath: "card2.png"
        ),
        VideoHistoryItemModel(
            id: UUID(),
            videoFilePath: "mock3.mp4",
            thumbnailPath: "card3.png"
        ),
        VideoHistoryItemModel(
            id: UUID(),
            videoFilePath: "mock4.mp4",
            thumbnailPath: "card4.png"
        ),
        VideoHistoryItemModel(
            id: UUID(),
            videoFilePath: "mock5.mp4",
            thumbnailPath: "card5.png"
        ),
        VideoHistoryItemModel(
            id: UUID(),
            videoFilePath: "mock6.mp4",
            thumbnailPath: "card6.png"
        )
    ]
}
