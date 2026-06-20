//
//  PinkProgressView.swift
//  aiGeneratorTestTask
//

import SwiftUI

struct PinkProgressView: View {
    
    var body: some View {
        ProgressView()
            .tint(.lightPink)
    }
    
    func largeScale() -> some View {
        modifier(LargeScale())
    }
}

private extension PinkProgressView {
    struct LargeScale: ViewModifier {
        func body(content: Content) -> some View {
            content
                .scaleEffect(2)
                .frame(maxHeight: .infinity, alignment: .center)
        }
    }
}

#Preview {
    PinkProgressView().largeScale()
}
