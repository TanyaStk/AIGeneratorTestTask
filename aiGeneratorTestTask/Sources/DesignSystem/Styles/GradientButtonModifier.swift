//
//  GradientButtonModifier.swift
//  aiGeneratorTestTask
//

import SwiftUI

private struct GradientButtonModifier: ViewModifier {
    
    let isEnabled: Bool
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(isEnabled ? .accent : .accent.opacity(0.3))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(buttonBackground)
            .clipShape(.rect(cornerRadius: 24, style: .continuous))
    }
    
    @ViewBuilder
    private var buttonBackground: some View {
        if isEnabled {
            BluePinkGradientView()
        } else {
            Color.card
        }
    }
}

extension View {
    func asGradientButton(_ isEnabled: Bool = true) -> some View {
        modifier(GradientButtonModifier(isEnabled: isEnabled))
    }
}

#Preview {
    Text("Button")
        .asGradientButton(true)
    
    Text("Button")
        .asGradientButton(false)
}
