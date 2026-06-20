//
//  VideoTemplatesResponse.swift
//  aiGeneratorTestTask
//


import Foundation

struct VideoTemplatesResponse: Decodable {
    let id: Int
    let applicationId: String
    let templates: [TemplateDTO]
}

struct TemplateDTO: Decodable {
    let templateId: Int
    let name: String
    let category: String
    let templateModel: String
    let qualities: [String]
    let previewSmall: String
    let previewLarge: String
    let isActive: Bool
}

extension TemplateDTO {
    func toVideoTemplate() -> VideoTemplate {
        .init(
            id: templateId,
            title: name,
            categoryName: category,
            photoSlotCount: 1,
            availableQualities: qualities,
            previewURL: URL(string: previewSmall)
        )
    }
}
