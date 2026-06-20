//
//  VideoSavedConfirmationView.swift
//  aiGeneratorTestTask
//

import SwiftUI

struct VideoSavedConfirmationView: View {
    
    var body: some View {
        VStack(spacing: 8) {
            GradientImageView(image: .Images.Common.Icons.check, size: 40)
            
            Text("Video has been saved\nto your gallery")
                .foregroundStyle(.accent)
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
        }
        .padding(24)
        .background(.card)
        .clipShape(.rect(cornerRadius: 24, style: .continuous))
    }
}

#Preview {
    VideoSavedConfirmationView()
}
