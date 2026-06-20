//
//  GeneratingView.swift
//  aiGeneratorTestTask
//
//

import SwiftUI

struct GeneratingView: View {
    
    @State private var isPulsing = false
    @State private var isRotating = false

    var body: some View {
        VStack(spacing: 40) {
            orbView
            
            VStack(spacing: 8) {
                Text("Generating...")
                    .font(.system(size: 20, weight: .bold))
                Text("We're creating the best result for you")
                    .font(.system(size: 16, weight: .regular))
                    .opacity(0.6)
            }
            .foregroundStyle(.accent)
        }
        .frame(maxHeight: .infinity)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true)) {
                isPulsing = true
            }
            withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                isRotating = true
            }
        }
    }

    private var orbView: some View {
        ZStack {
            // Outer glow rings
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.lightPink.opacity(0.15 - Double(i) * 0.04),
                                .clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 120 + CGFloat(i * 30)
                        )
                    )
                    .frame(width: 240 + CGFloat(i * 60), height: 240 + CGFloat(i * 60))
                    .scaleEffect(isPulsing ? 1.08 : 0.95)
            }

            // Core orb
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.lightPink,
                            Color.lightPink.opacity(0.8),
                            Color.lightPink.opacity(0.6)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 200, height: 200)
                .scaleEffect(isPulsing ? 1.06 : 0.96)
                .shadow(color: Color(red: 0.75, green: 0.55, blue: 0.9).opacity(0.6), radius: 40)

            // Shimmer overlay
            Circle()
                .fill(
                    EllipticalGradient(
                        colors: [.card.opacity(0.35), .clear],
                        center: .init(x: 0.35, y: 0.3),
                        startRadiusFraction: 0,
                        endRadiusFraction: 0.55
                    )
                )
                .frame(width: 200, height: 200)
                .scaleEffect(isPulsing ? 1.06 : 0.96)
                .rotationEffect(.degrees(isRotating ? 360 : 0))
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        GeneratingView()
    }
}
