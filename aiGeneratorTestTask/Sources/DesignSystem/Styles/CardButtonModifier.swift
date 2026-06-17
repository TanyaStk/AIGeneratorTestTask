//
//  CardButtonModifier.swift
//  aiGeneratorTestTask
//

import SwiftUI

private struct CardButtonModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(.accent)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.card.opacity(0.6))
            )
    }
}

extension View {
    func asCardButton() -> some View {
        modifier(CardButtonModifier())
    }
}

#Preview {
    Text("Button")
        .asCardButton()
}
