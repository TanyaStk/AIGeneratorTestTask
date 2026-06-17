//
//  GradientImageView.swift
//  aiGeneratorTestTask
//

import SwiftUI

struct GradientImageView: View {
    
    let image: ImageResource
    let size: CGFloat
    
    var body: some View {
        Image(image)
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(BluePinkGradientStyle())
            .scaledToFit()
            .frame(width: size, height: size)
    }
}

#Preview {
    GradientImageView(image: .Images.Common.Icons.magicPencil, size: 24)
}
