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

#Preview {
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
        VideoTemplateCardView(template: VideoTemplate(title: "TitleTitleTitleTitleTitleTitleTitle", categoryName: "Popular"))
        VideoTemplateCardView(template: VideoTemplate(title: "Title", categoryName: "Popular"))
    }
    .padding()
    .background(Color.black)
}
