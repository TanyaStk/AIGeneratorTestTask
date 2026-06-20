//
//  VideoGenerationViewModel.swift
//  aiGeneratorTestTask
//

import Foundation
import Combine

final class VideoGenerationViewModel: ObservableObject {
    
    @Injected(\.videoTemplateProvider) private var service
    
    @Published private(set) var state = State()
    
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
        } catch {
            state.errorMessage = error.userFacingMessage
        }
    }
    
    func loadTemplates() async {
        guard let selectedCategory = state.selectedCategory else { return }
        
        state.isLoading = true
        defer { state.isLoading = false }
        
        do {
            state.templates = try await service.fetchTemplates(for: selectedCategory)
        } catch {
            state.errorMessage = error.userFacingMessage
        }
    }
    
    func select(category: VideoCategory) {
        guard category != state.selectedCategory else { return }
        
        state.selectedCategory = category
        
        Task {
            await loadTemplates()
        }
    }
    
    func retry() {
        Task {
            if state.categories.isEmpty {
                await loadCategories()
                await loadTemplates()
            } else {
                await loadTemplates()
            }
        }
    }
    
    func dismissError() {
        state.errorMessage = nil
    }
}

extension VideoGenerationViewModel {
    struct State {
        var categories: [VideoCategory] = []
        var templates: [VideoTemplate] = []
        var selectedCategory: VideoCategory?
        var isLoading = false
        var errorMessage: String?
    }
}
