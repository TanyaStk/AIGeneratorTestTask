//
//  VideoTemplateProvider.swift
//  aiGeneratorTestTask
//


import Foundation

protocol VideoTemplateProvider {
    func fetchCategories() async throws -> [VideoCategory]
    func fetchTemplates(for category: VideoCategory) async throws -> [VideoTemplate]
}

struct MockVideoTemplateService: VideoTemplateProvider {
    func fetchCategories() async throws -> [VideoCategory] {
        try await Task.sleep(nanoseconds: 300_000_000)
        
        return ["Popular", "Funny", "Sad", "Trends", "Dance"].map(VideoCategory.init)
    }

    func fetchTemplates(for category: VideoCategory) async throws -> [VideoTemplate] {
        try await Task.sleep(nanoseconds: 300_000_000)
        
        let names = ["Clay Fool", "Neon Pulse", "Dream Walker", "Retro Glitch", "Mirror Self", "Cyber Angel"]
        let slots = [1, 2, 1, 2, 1, 2]
        
        return zip(names, slots).map { name, slot in
            VideoTemplate(title: name, categoryName: category.name, photoSlotCount: slot)
        }
    }
}
