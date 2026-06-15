//
//  AIToolCardView.swift
//  aiGeneratorTestTask
//

import SwiftUI

struct AIToolCardView: View {
    
    let tool: AIToolType
    let action: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            iconBadge
            titleStack
            
            if let footer = tool.footerText {
//                footerView(footer)
//                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(background)
        .clipShape(.rect(cornerRadius: 24, style: .continuous))
        .contentShape(.rect)
        .onTapGesture { action?() }
    }
    
    private var iconBadge: some View {
        icon
            .frame(width: 24, height: 24)
            .padding(8)
            .background(
                Circle().fill(tool.isFeatured ? Color.white.opacity(0.15) : Color.white.opacity(0.05))
            )
            .padding(.top, tool.isFeatured ? 8 : 0)
    }
    
    @ViewBuilder
    private var icon: some View {
        if tool.isFeatured {
            Image(tool.image)
                .resizable()
                .scaledToFit()
        } else {
            GradientImageView(image: tool.image)
        }
    }
    
    @ViewBuilder
    private var background: some View {
        if tool.isFeatured {
            Image(.Images.MainScreen.generateVideoButtonBackground)
                .resizable()
                .scaledToFill()
        } else {
            Color.card.opacity(0.7)
        }
    }
    
    @ViewBuilder
    private var titleStack: some View {
        VStack(alignment: .leading, spacing: tool.isFeatured ? 12 : 8) {
            Text(tool.title)
                .font(.system(size: 20, weight: .medium))
                .fixedSize(horizontal: false, vertical: true)
            
            Text(tool.subtitle)
                .font(.caption)
                .opacity(tool.isFeatured ? 0.7 : 0.5)
        }
        .foregroundStyle(.white)
    }
    
    private func footerView(_ text: String) -> some View {
        HStack {
            Text(text)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.black)
            Spacer()
            Image(systemName: "play.fill")
                .font(.caption)
                .foregroundStyle(.black)
                .padding(8)
                .background(Circle().fill(Color.white.opacity(0.5)))
        }
    }
}

private extension AIToolCardView {
    
    struct FeatureCardView: View {
        
        let tool: AIToolType
            
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Image(tool.image)
                    .resizable()
                    .scaledToFit()
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(tool.title)
                        .font(.system(size: 20, weight: .medium))
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(tool.subtitle)
                        .font(.caption)
                        .opacity(0.7)
                }
                .foregroundStyle(.white)
                
                if let footer = tool.footerText {
    //                footerView(footer)
    //                    .frame(maxHeight: .infinity, alignment: .bottom)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background {
                Image(.Images.MainScreen.generateVideoButtonBackground)
                    .resizable()
                    .scaledToFill()
            }
        }
    }
    
}

#Preview {
    HStack {
        AIToolCardView(tool: .photoToVideo) {}
        
        VStack {
            AIToolCardView(tool: .rewriteText, action: nil)
            AIToolCardView(tool: .summarizeText, action: nil)
        }
    }
    .frame(height: 313)
    .padding(16)
}
