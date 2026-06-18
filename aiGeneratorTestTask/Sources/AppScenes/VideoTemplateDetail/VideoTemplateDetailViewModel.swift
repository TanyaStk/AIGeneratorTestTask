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
            selectedQuality: selected.availableQualities.first ?? "1080p",
            selectedFormat: VideoFormat.horizontal.rawValue
        )
    }
    
    func didPickImage(_ image: UIImage, slotIndex: Int) {
        setSlot(.filled(image, deleteAction: { [weak self] in
            self?.removeImage(slotIndex: slotIndex)
        }), at: slotIndex)
    }
    
    func slotState(for index: Int) -> PhotoSlotState {
        state.photoSlots[state.currentTemplate.id]?[index] ??
            .empty(loadAction: { [weak self] in
                self?.tapSlot(index: index)
            })
    }
    
    func didStartPicking(slotIndex: Int) {
        setSlot(.loading, at: slotIndex)
    }
    
    func onTemplateChanged() {
        if !state.currentTemplate.availableQualities.contains(state.selectedQuality) {
            state.selectedQuality = state.currentTemplate.availableQualities.first ?? "1080p"
        }
    }
    
    func setupRequest() -> VideoGenerationRequest? {
        guard case .filled(let image, _) = state.photoSlots[state.currentTemplate.id]?.first?.value else {
            return nil
        }
        
        let request = VideoGenerationRequest(
            templateId: state.currentTemplate.id,
            templateTitle: state.currentTemplate.title,
            photoSlotCount: state.photoSlots.count,
            image: image,
            duration: 5,
            quality: state.selectedQuality
        )
        
        return request
    }
}

private extension VideoTemplateDetailViewModel {
    func setSlot(_ photoSlotState: PhotoSlotState, at index: Int) {
        var slots = state.photoSlots[state.currentTemplate.id] ?? [:]
        slots[index] = photoSlotState
        state.photoSlots[state.currentTemplate.id] = slots
    }
    
    func removeImage(slotIndex: Int) {
        state.photoSlots[state.currentTemplate.id]?[slotIndex] = nil
    }
    
    func tapSlot(index: Int) {
        state.pickingSlotIndex = index
        state.showPhotoPicker = true
    }
}

extension VideoTemplateDetailViewModel {
    struct State {
        var templates: [VideoTemplate]
        var currentIndex: Int
        var photoSlots: [Int: [Int: PhotoSlotState]] = [:]
        var selectedQuality: String
        var selectedFormat: String
        var pickingSlotIndex: Int? = nil
        var showPhotoPicker = false
        
        var currentTemplate: VideoTemplate {
            templates[currentIndex]
        }
        
        var isCreateEnabled: Bool {
            let slots = photoSlots[currentTemplate.id] ?? [:]
            let isAllSlotsFilled = slots.values.allSatisfy {
                if case .filled = $0 {
                    return true
                } else {
                    return false
                }
            }
            
            return slots.count == currentTemplate.photoSlotCount && isAllSlotsFilled
            
        }
    }
    
    enum VideoFormat: String, CaseIterable {
        case horizontal = "16:9"
        case vertical = "9:16"
        case square = "1:1"
    }
}
