//
//  VideoTemplateCardView.swift
//  aiGeneratorTestTask
//


import SwiftUI

struct VideoTemplateCardView: View {
    
    let template: VideoTemplate
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image(.Images.VideoGeneration.templateMock)
                .resizable()
                .clipShape(.rect(cornerRadius: 16, style: .continuous))
            
            Text(template.title)
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(.accent)
                .multilineTextAlignment(.center)
                .padding(8)
        }
    }
}
