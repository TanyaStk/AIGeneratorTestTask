//
//  ErrorView.swift
//  aiGeneratorTestTask
//

import SwiftUI

struct ErrorView: View {
    
    let message: String
    
    var retryAction: () -> ()
    var cancelAction: () -> ()
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(.lightPink)
                
                Text("Generation failed")
                    .font(.headline)
                    .foregroundStyle(.white)
            }
            
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)
            
            VStack(spacing: 8) {
                Button(action: retryAction) {
                    Text("Try Again")
                        .asGradientButton()
                }
                
                Button(action: cancelAction) {
                    Text("Cancel")
                        .asCardButton()
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.card)
        )
    }
}

#Preview {
    ErrorView(
        message: VideoGenerationError.networkFailure.userFacingMessage,
        retryAction: {},
        cancelAction: {}
    )
}
