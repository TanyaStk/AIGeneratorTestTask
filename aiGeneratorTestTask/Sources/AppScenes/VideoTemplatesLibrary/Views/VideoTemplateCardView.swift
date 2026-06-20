//
//  VideoTemplateCardView.swift
//  aiGeneratorTestTask
//


import SwiftUI
import AVFoundation

struct VideoTemplateCardView: View {
    
    let template: VideoTemplate
    
    @State private var thumbnail: UIImage?
    @State private var isLoading = true
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.card
            
            if let thumbnail {
                Image(uiImage: thumbnail)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if isLoading {
                PinkProgressView()
                    .frame(maxHeight: .infinity)
            }

            Text(template.title)
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(.accent)
                .multilineTextAlignment(.center)
                .padding(8)
        }
        .task(id: template.previewURL) {
            await loadThumbnail()
        }
    }
    
    private func loadThumbnail() async {
        guard let url = template.previewURL, thumbnail == nil else {
            isLoading = false; return
        }
        
        isLoading = true
//        thumbnail = nil
        
        let asset = AVURLAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        generator.maximumSize = CGSize(width: 400, height: 400)
        
        guard let cgImage = try? await generator.image(
            at: CMTime(seconds: 0.5, preferredTimescale: 60)
        ).image else {
            isLoading = false
            return
        }
        
        thumbnail = UIImage(cgImage: cgImage)
        isLoading = false
    }
}

#Preview {
    VideoTemplateCardView(template: .init(
        id: 0,
        title: "template",
        categoryName: "popular",
        availableQualities: [],
        previewURL: Bundle.main.url(forResource: "testVideo", withExtension: "mp4")!
    ))
    .frame(width: 171, height: 232)
    .clipShape(.rect(cornerRadius: 24, style: .continuous))
}
