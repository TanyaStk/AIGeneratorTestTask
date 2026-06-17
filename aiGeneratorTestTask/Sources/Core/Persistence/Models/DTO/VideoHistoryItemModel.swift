//
//  VideoHistoryItemModel.swift
//  aiGeneratorTestTask
//

import Foundation

struct VideoHistoryItemModel: Identifiable {
    let id: UUID
    let videoFilePath: String
    let thumbnailPath: String?
}
