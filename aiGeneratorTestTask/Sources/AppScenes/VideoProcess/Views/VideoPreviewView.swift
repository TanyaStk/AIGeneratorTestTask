import SwiftUI
import AVKit

struct VideoPreviewView: View {
    let url: URL

    @State private var thumbnail: UIImage?
    @State private var isPlaying = false

    var body: some View {
        ZStack {
            thumbnailLayer
            playButton
        }
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .task { await generateThumbnail() }
        .fullScreenCover(isPresented: $isPlaying) {
            FullScreenVideoPlayer(url: url)
                .ignoresSafeArea()
        }
    }

    // MARK: - Thumbnail

    @ViewBuilder
    private var thumbnailLayer: some View {
        if let thumbnail {
            Image(uiImage: thumbnail)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            Color(white: 0.12)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    // MARK: - Play button

    private var playButton: some View {
        Button {
            isPlaying = true
        } label: {
            Image(systemName: "play.fill")
                .font(.system(size: 36))
                .foregroundStyle(.white)
                .padding(24)
                .background(Circle().fill(Color.black.opacity(0.45)))
        }
    }

    // MARK: - Thumbnail generation

    private func generateThumbnail() async {
        let asset = AVURLAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        generator.maximumSize = CGSize(width: 600, height: 600)

        let time = CMTime(seconds: 0.5, preferredTimescale: 60)

        guard let cgImage = try? await generator.image(at: time).image else { return }
        thumbnail = UIImage(cgImage: cgImage)
    }
}