//
//  PaywallAlertsDisplay.swift
//  aiGeneratorTestTask
//

import SwiftUI

struct PaywallAlertsDisplay: ViewModifier {
    
    var alertType: PurchaseAlertType?
    
    @Binding var isPresented: Bool
    
    var retryAction: () -> ()
    
    func body(content: Content) -> some View {
        content
            .alert("Something went wrong", isPresented: $isPresented) {
                Button("Cancel", role: .cancel) {}
                Button("Try Again") {
                    retryAction()
                }
            } message: {
                Text(alertType?.message ?? "")
            }
    }
}
