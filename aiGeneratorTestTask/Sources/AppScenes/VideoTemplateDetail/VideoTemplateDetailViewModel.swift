//
//  VideoTemplateDetailViewModel.swift
//  aiGeneratorTestTask
//


import Foundation
import UIKit
import Combine

@MainActor
final class VideoTemplateDetailViewModel: ObservableObject {
    
    @Published var state: State

    init(selected: VideoTemplate, all: [VideoTemplate]) {
        self.state = .init(
            templates: all,
            currentIndex: all.firstIndex(of: selected) ?? 0,
            selectedFormat: selected.availableFormats.first ?? "16:9",
            selectedQuality: selected.availableQualities.first ?? "1080p"
        )
    }
    
    func tapSlot(index: Int) {
        state.pickingSlotIndex = index
        state.showPhotoPicker = true
    }

    func didPickImage(_ image: UIImage, slotIndex: Int) {
        var slots = state.photoSlots[state.currentTemplate.id] ?? [:]
        
        slots[slotIndex] = image
        state.photoSlots[state.currentTemplate.id] = slots
    }

    func removeImage(slotIndex: Int) {
        state.photoSlots[state.currentTemplate.id]?[slotIndex] = nil
    }

    func image(for slotIndex: Int) -> UIImage? {
        state.photoSlots[state.currentTemplate.id]?[slotIndex]
    }

    func onTemplateChanged() {
        if !state.currentTemplate.availableFormats.contains(state.selectedFormat) {
            state.selectedFormat = state.currentTemplate.availableFormats.first ?? "16:9"
        }
        if !state.currentTemplate.availableQualities.contains(state.selectedQuality) {
            state.selectedQuality = state.currentTemplate.availableQualities.first ?? "1080p"
        }
    }

    func createTapped() {
        // Hook up generation logic here
    }
}

extension VideoTemplateDetailViewModel {
    struct State {
        var templates: [VideoTemplate]
        var currentIndex: Int
        var photoSlots: [UUID: [Int: UIImage]] = [:]
        var selectedFormat: String
        var selectedQuality: String
        var pickingSlotIndex: Int? = nil
        var showPhotoPicker = false
        
        var currentTemplate: VideoTemplate {
            templates[currentIndex]
        }
        
        var isCreateEnabled: Bool {
            let slots = photoSlots[currentTemplate.id] ?? [:]
            
            return slots.count == currentTemplate.photoSlotCount
        }
    }
}
