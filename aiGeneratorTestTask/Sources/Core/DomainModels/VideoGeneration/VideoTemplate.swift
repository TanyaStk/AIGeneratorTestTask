//
//  VideoTemplate.swift
//  aiGeneratorTestTask
//
//

import Foundation

struct VideoTemplate: Identifiable, Hashable {
    let id: Int
    let title: String
    let categoryName: String
    let photoSlotCount: Int
    let availableQualities: [String]
    let previewURL: URL?

    init(
        id: Int,
        title: String,
        categoryName: String,
        photoSlotCount: Int = 1,
        availableQualities: [String],
        previewURL: URL?
    ) {
        self.id = id
        self.title = title
        self.categoryName = categoryName
        self.photoSlotCount = photoSlotCount
        self.availableQualities = availableQualities
        self.previewURL = previewURL
    }
}
