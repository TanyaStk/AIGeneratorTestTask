//
//  ReplaceButtonView.swift
//  aiGeneratorTestTask
//

import SwiftUI

struct ReplaceButton: View {
    
    let title: String
    var onReplace: () -> ()
    
    var body: some View {
        Button(action: onReplace) {
            HStack(spacing: 6) {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .font(.subheadline.weight(.bold))
                
                Text(title)
                    .font(.system(size: 14, weight: .regular))
            }
            .foregroundStyle(.accent)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(Color.card.opacity(0.4))
            )
            .padding(.top, 16)
            .padding(.trailing, 16)
        }
    }
}

#Preview {
    ReplaceButton(title: "Replace", onReplace: {})
}
