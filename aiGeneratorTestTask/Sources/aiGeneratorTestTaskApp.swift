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
        Apphud.start(apiKey: "app_FmCjFTwjWpcLSafxT8vCDeVffJyfFS")
        userID = Apphud.userID()
    }
}
