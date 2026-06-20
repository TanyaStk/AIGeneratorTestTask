//
//  AppRouter.swift
//  aiGeneratorTestTask
//

import Foundation
import Combine
import SwiftUI

final class AppRouter: ObservableObject {
    
    @Published var path = NavigationPath()
    @Published var shouldShowPaywall = false
    
    func push(_ route: Destination) {
        path.append(route)
    }
    
    func goBack() {
        path.removeLast()
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func togglePaywallVisibility() {
        shouldShowPaywall.toggle()
    }
}
