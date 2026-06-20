//
//  MainScreenViewModel.swift
//  aiGeneratorTestTask
//

import Foundation
import Combine

final class MainScreenViewModel: ObservableObject {
    
    @Injected(\.apphudService) private var apphudService
    
    var userHasPremium: Bool {
        apphudService.hasActiveSubscription
    }
}
