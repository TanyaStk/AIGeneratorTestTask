//
//  VideoGenerationViewModel.swift
//  aiGeneratorTestTask
//

import Foundation
import Combine

final class VideoGenerationViewModel: ObservableObject {
    
    @Published private(set) var state = State()

    private let service: VideoTemplateProvider

    init(service: VideoTemplateProvider = MockVideoTemplateService()) {
        self.service = service
    }

    func onAppear() async {
        guard state.categories.isEmpty else { return }
        
        await loadCategories()
        await loadTemplates()
    }

    func loadCategories() async {
        do {
            let fetched = try await service.fetchCategories()
            state.categories = fetched
            
            if state.selectedCategory == nil {
                state.selectedCategory = fetched.first
            }
        } catch {}
    }

    func loadTemplates() async {
        guard let selectedCategory = state.selectedCategory else { return }
        
        state.isLoading = true
        defer { state.isLoading = false }
        
        do {
            state.templates = try await service.fetchTemplates(for: selectedCategory)
        } catch {}
    }

    func select(category: VideoCategory) {
        guard category != state.selectedCategory else { return }
        
        state.selectedCategory = category
        
        Task {
            await loadTemplates()
        }
    }

    func templateTapped(_ template: VideoTemplate) {
        
    }
}

extension VideoGenerationViewModel {
    struct State {
        var categories: [VideoCategory] = []
        var templates: [VideoTemplate] = []
        var selectedCategory: VideoCategory?
        var isLoading = false
    }
}
