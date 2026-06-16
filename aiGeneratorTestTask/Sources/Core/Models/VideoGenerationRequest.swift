//
//  VideoGenerationRequest.swift
//  aiGeneratorTestTask
//

import Foundation

struct VideoGenerationRequest: Hashable {
    let templateId: UUID
    let templateTitle: String
    let photoSlotCount: Int
}
