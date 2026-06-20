//
//  NavigationTitleModifier.swift
//  aiGeneratorTestTask
//

import SwiftUI

private struct NavigationTitleModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 20, weight: .semibold))
            .foregroundStyle(.accent)
    }
}

extension View {
    func asNavigationTitle() -> some View {
        modifier(NavigationTitleModifier())
    }
}

#Preview {
    Text("NavigationTitleModifier")
        .asNavigationTitle()
        .background(.black)
}
