//
//  PhotoSlotStateView.swift
//  aiGeneratorTestTask
//

import SwiftUI

extension VideoTemplateDetailView {
    
    struct PhotoSlotStateView: View {
        
        let state: PhotoSlotState
        
        var body: some View {
            switch state {
            case .empty(let action):
                Button(action: action) {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .strokeBorder(BluePinkGradientStyle(), lineWidth: 1)
                        .frame(width: 100, height: 100)
                        .overlay {
                            Image(systemName: "plus")
                                .font(.title2.weight(.light))
                                .foregroundStyle(.accent)
                        }
                }
            case .loading:
                ProgressView()
                    .tint(.gradientBlue)
                    .frame(width: 100, height: 100)
                    .background(.card)
                    .clipShape(.rect(cornerRadius: 16, style: .continuous))
                
            case .filled(let uIImage, let action):
                ImageWithDeleteButton(image: uIImage, deleteAction: action)
            }
        }
    }
}

#Preview {
    let templates = (1...6).map {
        VideoTemplate(title: "Template \($0)", categoryName: "Popular", photoSlotCount: $0 % 2 + 1)
    }
    
    VideoTemplateDetailView(
        viewModel: VideoTemplateDetailViewModel(selected: templates[0], all: templates)
    )
}
