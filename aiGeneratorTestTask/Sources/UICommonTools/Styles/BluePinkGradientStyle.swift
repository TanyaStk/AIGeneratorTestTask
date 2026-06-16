//
//  BluePinkGradientStyle.swift
//  aiGeneratorTestTask
//

import SwiftUI

struct BluePinkGradientStyle: ShapeStyle {
    
    func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
        LinearGradient(
            colors: [.gradientBlue, .gradientPink],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

#Preview {
    Circle()
        .foregroundStyle(BluePinkGradientStyle())
}
