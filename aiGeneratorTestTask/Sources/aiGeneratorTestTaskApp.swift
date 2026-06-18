//
//  aiGeneratorTestTaskApp.swift
//  aiGeneratorTestTask
//

import SwiftUI
import ApphudSDK

@main
struct aiGeneratorTestTaskApp: App {
    
    @AppStorage("userID")
    private var userID: String = ""
    
    @Injected(\.apphudService)
    private var apphudService
    
    init() {
        setupApphud()
    }
    
    var body: some Scene {
        WindowGroup {
            MainScreenView()
                .embedRouter()
                .colorScheme(.dark)
        }
    }
    
    private func setupApphud() {
        apphudService.start(with: AppConstants.Apphud.key)
        userID = apphudService.getUserID()
    }
}
