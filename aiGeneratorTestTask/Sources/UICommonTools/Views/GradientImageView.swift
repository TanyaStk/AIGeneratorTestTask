//
//  GradientImageView.swift
//  aiGeneratorTestTask
//

import SwiftUI

struct GradientImageView: View {
    
    let image: ImageResource
    
    var body: some View {
        Image(image)
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(.linearGradient(
                .init(colors: [.gradientBlue, .gradientPink]),
                startPoint: .top,
                endPoint: .bottom)
            )
            .scaledToFit()
    }
}

#Preview {
    GradientImageView(image: .Images.Common.Icons.magicPencil)
        .frame(width: 24, height: 24)
}
