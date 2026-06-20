//
//  CategoryPillView.swift
//  aiGeneratorTestTask
//
//


import SwiftUI

struct CategoryPillView: View {
    
    let category: VideoCategory
    let isSelected: Bool

    var body: some View {
        Text(category.name)
            .font(.system(size: 14, weight: .regular))
            .foregroundStyle(.accent)
            .opacity(isSelected ? 1 : 0.5)
            .padding(.horizontal, 18)
            .padding(.vertical, 8)
            .background(background)
            .clipShape(.capsule)
    }

    @ViewBuilder
    private var background: some View {
        if isSelected {
            BluePinkGradientView()
        } else {
            Color.card.opacity(0.6)
        }
    }
}

#Preview {
    HStack {
        CategoryPillView(category: VideoCategory("Popular"), isSelected: true)
        CategoryPillView(category: VideoCategory("Funny"), isSelected: false)
    }
    .padding()
    .background(Color.background)
}
