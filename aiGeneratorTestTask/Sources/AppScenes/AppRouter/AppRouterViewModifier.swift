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
                        .environmentObject(router)
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
            PhotoToViewGenerationView()
        case .aiChat:
            AIChatView()
        }
    }
}

extension View {
    func embedRouter() -> some View {
        modifier(AppRouterViewModifier())
    }
}
