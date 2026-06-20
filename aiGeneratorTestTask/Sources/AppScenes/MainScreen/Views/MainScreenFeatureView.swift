//
//  MainScreenFeatureView.swift
//  aiGeneratorTestTask
//

import SwiftUI

struct MainScreenFeatureView: View {
    let tool: AIToolType
    let action: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            iconBadge
            titleStack
            
            Spacer()
            
            footerView
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(background)
        .clipShape(.rect(cornerRadius: 24, style: .continuous))
        .contentShape(.rect)
        .onTapGesture { action?() }
    }
    
    private var iconBadge: some View {
        Image(tool.image)
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 20)
            .padding(8)
            .background(
                Circle().fill(Color.accent.opacity(0.15))
            )
            .padding(.vertical, 8)
    }
    
    private var background: some View {
        Image(.Images.MainScreen.generateVideoButtonBackground)
            .resizable()
            .scaledToFill()
    }
    
    private var titleStack: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(tool.title)
                .font(.system(size: 20, weight: .medium))
            
            Text(tool.subtitle)
                .font(.system(size: 14, weight: .regular))
                .opacity(0.7)
        }
        .foregroundStyle(.accent)
    }
    
    @ViewBuilder
    private var footerView: some View {
        if let footer = tool.footerText {
            HStack {
                Text(footer)
                    .font(.system(size: 12, weight: .regular))
                
                Spacer()
                
                Image(.Images.MainScreen.roundedTriangle)
            }
            .foregroundStyle(.accent)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(.accent.opacity(0.3))
            .clipShape(.capsule)
        }
    }
}

#Preview {
    MainScreenFeatureView(tool: .photoToVideo, action: nil)
        .frame(width: 179, height: 313)
}
