//
//  VideoTemplateProvider.swift
//  aiGeneratorTestTask
//


import Foundation

protocol VideoTemplateProvider {
    func fetchCategories() async throws -> [VideoCategory]
    func fetchTemplates(for category: VideoCategory) async throws -> [VideoTemplate]
}

final class VideoTemplateService: VideoTemplateProvider {
    
    private let network: NetworkServiceType
    private var allTemplates: [VideoTemplate] = []

    init(network: NetworkServiceType) {
        self.network = network
    }

    func fetchCategories() async throws -> [VideoCategory] {
        let response: VideoTemplatesResponse = try await network.get(
            path: APIConstants.Paths.templates
        )
        allTemplates = response.templates
            .filter(\.isActive)
            .map { $0.toVideoTemplate() }

        var seen = Set<String>()
        for template in allTemplates {
            seen.insert(template.categoryName)
        }
        
        return seen.map(VideoCategory.init)
    }

    func fetchTemplates(for category: VideoCategory) async throws -> [VideoTemplate] {
        if allTemplates.isEmpty {
            _ = try await fetchCategories()
        }
        
        return allTemplates.filter { $0.categoryName == category.name }
    }
}

// MARK: - MockVideoTemplateService

struct MockVideoTemplateService: VideoTemplateProvider {
    func fetchCategories() async throws -> [VideoCategory] {
        try await Task.sleep(nanoseconds: 300_000_000)
        
        return ["📈 Trending", "😂 Funny", "😢 Sad", "💃 Dance"].map(VideoCategory.init)
    }

    func fetchTemplates(for category: VideoCategory) async throws -> [VideoTemplate] {
        try await Task.sleep(nanoseconds: 300_000_000)
        
        return (1...6).map {
            VideoTemplate(
                id: $0,
                title: "Template \($0)",
                categoryName: category.name,
                availableQualities: [],
                previewURL: nil
            )
        }
    }
}
