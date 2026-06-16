//
//  NavigationBarView.swift
//  aiGeneratorTestTask
//

import SwiftUI

struct NavigationBarView<TitleContent: View, RightContent: View>: View {
    
    @Environment(\.dismiss) private var dismiss
    
    private let titleContent: TitleContent
    private let rightContent: RightContent?
    
    init(@ViewBuilder titleContent: () -> TitleContent,
         rightContent: (() -> RightContent)? = nil) {
        self.titleContent = titleContent()
        self.rightContent = rightContent?()
    }
    
    var body: some View {
        HStack {
            backButton
            
            Spacer()
            
            if let rightContent {
                rightContent
            }
        }
        .background(
            titleContent
        )
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
    }
    
    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(.Images.Common.Icons.arrowLeft)
                .resizable()
                .frame(width: 24, height: 24)
                .scaledToFit()
        }
    }
}

extension NavigationBarView where RightContent == EmptyView {
    init(@ViewBuilder content: () -> TitleContent) {
        self.titleContent = content()
        self.rightContent = nil
    }
}

#Preview {
    NavigationBarView {
        Text("View title")
            .foregroundStyle(.accent)
    }
    .background(Color.card.ignoresSafeArea())
    
    NavigationBarView {
        Text("View title")
            .foregroundStyle(.accent)
    } rightContent: {
        Button {
            
        } label: {
            Image(.Images.Common.Icons.reload)
        }
        
    }
    .background(Color.card.ignoresSafeArea())
}
