import SwiftUI

struct GeneratingView: View {
    @State private var isPulsing = false
    @State private var isRotating = false

    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            orbView
            VStack(spacing: 8) {
                Text("Generating...")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.white)
                Text("We're creating the best result for you")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.45))
            }
            Spacer()
        }
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
                                Color(red: 0.85, green: 0.65, blue: 0.9).opacity(0.15 - Double(i) * 0.04),
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
                            Color(red: 0.90, green: 0.75, blue: 0.95),
                            Color(red: 0.70, green: 0.55, blue: 0.85),
                            Color(red: 0.55, green: 0.40, blue: 0.75)
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
                        colors: [.white.opacity(0.35), .clear],
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