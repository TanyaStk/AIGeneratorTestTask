//
//  TypingIndicator.swift
//  aiGeneratorTestTask
//

import SwiftUI
import Combine

struct TypingIndicator: View {
    
    @State private var activeIndex = 0
    
    private let timer = Timer.publish(every: 0.7, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(index == activeIndex ?
                          AnyShapeStyle(BluePinkGradientStyle()) :
                            AnyShapeStyle(Color.accent.opacity(0.25))
                    )
                    .frame(width: index == activeIndex ? 19 : 10,
                           height: index == activeIndex ? 19 : 10
                    )
                    .animation(.easeInOut(duration: 0.6), value: activeIndex)
            }
        }
        .onReceive(timer) { _ in
            activeIndex = (activeIndex + 1) % 3
        }
    }
}

#Preview {
    ZStack {
        Color.background.ignoresSafeArea()
        
        TypingIndicator()
    }
}
