//
//  ImageWithDeleteButton.swift
//  aiGeneratorTestTask
//

import SwiftUI

extension VideoTemplateDetailView {
    
    struct ImageWithDeleteButton: View {
        
        let image: UIImage
        let deleteAction: (() -> ())?
        
        var body: some View {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(alignment: .topTrailing) {
                    Button {
                        deleteAction?()
                    } label: {
                        GradientImageView(image: .Images.Common.Icons.xMark)
                            .frame(width: 24, height: 24)
                            .padding(4)
                            .background(
                                Circle().fill(.accent)
                            )
                            .padding(.top, 16)
                            .padding(.trailing, 16)
                            .alignmentGuide(.trailing) { dimension in
                                dimension[HorizontalAlignment.center]
                            }
                            .alignmentGuide(.top) { dimension in
                                dimension[VerticalAlignment.center]
                            }
                    }
                }
        }
    }
}
