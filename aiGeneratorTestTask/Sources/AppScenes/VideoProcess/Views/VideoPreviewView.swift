//
//  VideoPreviewView.swift
//  aiGeneratorTestTask
//

import SwiftUI
import AVKit

struct VideoPreviewView: View {
    
    let url: URL?

    @State private var thumbnail: UIImage?
    @State private var isPlaying = false
    
    var body: some View {
        ZStack {
            thumbnailLayer
            playButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.card.opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .task { await generateThumbnail() }
        .fullScreenCover(isPresented: $isPlaying) {
            if let url {
                FullScreenVideoPlayerView(url: url)
                    .ignoresSafeArea()
            }
        }
    }

    @ViewBuilder
    private var thumbnailLayer: some View {
        if let thumbnail {
            Image(uiImage: thumbnail)
                .resizable()
                .scaledToFit()
                .clipped()
        }
    }

    private var playButton: some View {
        Button {
            isPlaying = true
        } label: {
            Image(.Images.Common.Icons.play)
                .resizable()
                .frame(width: 80, height: 80)
                .scaledToFit()
        }
    }

    private func generateThumbnail() async {
        guard let url else { return }
        
        let asset = AVURLAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        generator.maximumSize = CGSize(width: 600, height: 600)

        let time = CMTime(seconds: 0.5, preferredTimescale: 60)

        guard let cgImage = try? await generator.image(at: time).image else { return }
        thumbnail = UIImage(cgImage: cgImage)
    }
}
