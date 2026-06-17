//
//  VideoHistoryViewModel.swift
//  aiGeneratorTestTask
//
//

import UIKit
import Combine

@MainActor
final class VideoHistoryViewModel: ObservableObject {
    
    @Injected(\.videoHistoryRepository) private var repository
    @Injected(\.videoFileManager) private var fileManager
    
    @Published private(set) var state = State()
    
    init() {
        load()
    }
    
    func load() {
        do {
            state.items = try repository.fetchAll()
            loadThumbnails()
        } catch {
            state.errorMessage = error.localizedDescription
        }
    }
    
    private func loadThumbnails() {
        for item in state.items {
            if let image = fileManager.thumbnailImage(fileName: item.thumbnailPath) {
                state.thumbnails[item.id] = image
            }
        }
    }
}

extension VideoHistoryViewModel {
    struct State {
        var items: [VideoHistoryItemModel] = []
        var thumbnails: [UUID: UIImage] = [:]
        var errorMessage: String?
    }
}
