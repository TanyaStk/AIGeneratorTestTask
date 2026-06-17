//
//  HistoryEmptyView.swift
//  aiGeneratorTestTask
//

import SwiftUI

struct HistoryEmptyView: View {
    
    let type: ViewType
    
    var body: some View {
        VStack(spacing: 21) {
            GradientImageView(image: type.icon, size: 60)
            textStack
        }
    }
    
    private var textStack: some View {
        VStack(spacing: 8) {
            Text(type.title)
                .font(.system(size: 28, weight: .bold))
            
            Text(type.subtitle)
                .font(.system(size: 16, weight: .regular))
                .opacity(0.5)
                .multilineTextAlignment(.center)
        }
        .foregroundStyle(.accent)
    }
}

extension HistoryEmptyView {
    enum ViewType {
        case video
        case chat
        
        var title: String {
            switch self {
            case .video:
                "No videos yet"
            case .chat:
                "No chats yet"
            }
        }
        
        var subtitle: String {
            switch self {
            case .video:
                "Create your first video to see it here"
            case .chat:
                "Start a conversation to see\nyour history here"
            }
        }
        
        var icon: ImageResource {
            switch self {
            case .video:
                    .Images.Common.Icons.imageToVideo
            case .chat:
                    .Images.Common.Icons.magicPencil
            }
        }
    }
}

#Preview {
    HistoryEmptyView(type: .chat)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
}
