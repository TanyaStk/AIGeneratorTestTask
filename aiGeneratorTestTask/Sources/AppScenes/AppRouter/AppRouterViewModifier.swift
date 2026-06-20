//
//  AppRouterViewModifier.swift
//  aiGeneratorTestTask
//

import Foundation
import SwiftUI

struct AppRouterViewModifier: ViewModifier {
    
    @StateObject private var router = AppRouter()
    
    func body(content: Content) -> some View {
        NavigationStack(path: $router.path) {
            content
                .environmentObject(router)
                .navigationDestination(for: AppRouter.Destination.self) { destination in
                    routeView(for: destination)
                        .toolbar(.hidden, for: .navigationBar)
                        .environmentObject(router)
                }
                .fullScreenCover(isPresented: $router.shouldShowPaywall) {
                    PaywallView(viewModel: .init(completion: {
                        router.togglePaywallVisibility()
                    }))
                }
        }
    }
}

private extension AppRouterViewModifier {
    @ViewBuilder
    func routeView(for destination: AppRouter.Destination) -> some View {
        switch destination {
        case .settings:
            SettingsView()
        case .photoToVideoGeneration:
            VideoTemplatesLibraryView(viewModel: VideoTemplatesLibraryViewModel())
        case .aiChat:
            AIChatView(viewModel: AIChatViewModel())
        case .templateDetail(selected: let selected, all: let all):
            VideoTemplateDetailView(viewModel: VideoTemplateDetailViewModel(selected: selected, all: all))
        case .videoProcess(request: let request):
            VideoProcessView(viewModel: .init(request: request))
        case .videoHistory:
            VideoHistoryView(viewModel: .init())
        case .chatHistory:
            ChatHistoryView()
        }
    }
}

extension View {
    func embedRouter() -> some View {
        modifier(AppRouterViewModifier())
    }
}
