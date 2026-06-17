//
//  VideoCategory.swift
//  aiGeneratorTestTask
//


import Foundation

struct VideoCategory: Identifiable, Hashable {
    let id = UUID()
    let name: String
    
    init(_ name: String) {
        self.name = name
    }
}

struct VideoTemplate: Identifiable, Hashable {
    let id: UUID
    let title: String
    let categoryName: String
    let photoSlotCount: Int
    let availableFormats: [String]
    let availableQualities: [String]

    init(
        id: UUID = UUID(),
        title: String,
        categoryName: String,
        photoSlotCount: Int = 1,
        availableFormats: [String] = ["16:9", "9:16", "1:1"],
        availableQualities: [String] = ["1080p", "720p", "480p"]
    ) {
        self.id = id
        self.title = title
        self.categoryName = categoryName
        self.photoSlotCount = photoSlotCount
        self.availableFormats = availableFormats
        self.availableQualities = availableQualities
    }
}
