//
//  VideoGenerationRequest.swift
//  aiGeneratorTestTask
//
//

import UIKit

struct VideoGenerationRequest: Hashable {
    let templateId: Int
    let templateTitle: String
    let photoSlotCount: Int
    let image: UIImage?
    let duration: Int
    let quality: String
}
