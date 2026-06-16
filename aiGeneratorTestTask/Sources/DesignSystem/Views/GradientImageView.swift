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
            .foregroundStyle(BluePinkGradientStyle())
            .scaledToFit()
    }
}

#Preview {
    GradientImageView(image: .Images.Common.Icons.magicPencil)
        .frame(width: 24, height: 24)
}
