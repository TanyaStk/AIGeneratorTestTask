//
//  aiGeneratorTestTaskApp.swift
//  aiGeneratorTestTask
//

import SwiftUI
import ApphudSDK

#if DEBUG
import Atlantis
#endif


@main
struct aiGeneratorTestTaskApp: App {
    
    @Injected(\.apphudService)
    private var apphudService
    
    init() {
        setupApphud()
        
#if DEBUG
        Atlantis.start()
#endif
    }
    
    var body: some Scene {
        WindowGroup {
            MainScreenView()
                .embedRouter()
                .preferredColorScheme(.dark)
        }
    }
    
    private func setupApphud() {
        apphudService.start(with: AppConstants.Apphud.key)
    }
}
