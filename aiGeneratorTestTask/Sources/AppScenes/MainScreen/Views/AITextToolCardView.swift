//
//  AITextToolCardView.swift
//  aiGeneratorTestTask
//

import SwiftUI

struct AITextToolCardView: View {
    
    let tool: AIToolType
    let action: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            iconBadge
            titleStack
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(.card.opacity(0.7))
        .clipShape(.rect(cornerRadius: 24, style: .continuous))
        .contentShape(.rect)
        .onTapGesture { action?() }
    }
    
    private var iconBadge: some View {
        GradientImageView(image: tool.image, size: 20)
            .padding(8)
            .background(
                Circle().fill(.accent.opacity(0.05))
            )
            .padding(.bottom, 16)
    }
    
    private var titleStack: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(tool.title)
                .font(.system(size: 16, weight: .medium))
                .fixedSize(horizontal: false, vertical: true)
            
            Text(tool.subtitle)
                .font(.system(size: 12, weight: .medium))
                .opacity(0.5)
        }
        .foregroundStyle(.accent)
    }
}

#Preview {
    HStack {
        MainScreenFeatureView(tool: .photoToVideo, action: nil)
        
        VStack {
            AITextToolCardView(tool: .rewriteText, action: nil)
            AITextToolCardView(tool: .summarizeText, action: nil)
        }
    }
    .frame(height: 313)
    .padding(16)
}
