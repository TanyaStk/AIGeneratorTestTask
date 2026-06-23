//
//  VideoTemplateCardView.swift
//  aiGeneratorTestTask
//

import SwiftUI
import VideoPlayer

struct VideoTemplateCardView: View {
    
    let template: VideoTemplate
    let isScrolling: Bool
    let isVisible: Bool
    
    @State private var isPlaying = false
    @State private var thumbnail: UIImage?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.card
            
            if let thumbnail {
                Image(uiImage: thumbnail)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .transition(.opacity)
            }
            
            if isVisible, let url = template.previewURL {
                VideoPlayer(url: url, play: $isPlaying)
                    .contentMode(.scaleAspectFill)
                    .autoReplay(true)
                    .mute(true)
            }
            
            LinearGradient(
                colors: [.clear, .black.opacity(0.6)],
                startPoint: .center,
                endPoint: .bottom
            )
            
            Text(template.title)
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(.accent)
                .multilineTextAlignment(.center)
                .padding(8)
        }
        .onChange(of: isVisible) {
            updatePlayback(visible: $0, scrolling: isScrolling)
        }
        .onChange(of: isScrolling) {
            updatePlayback(visible: isVisible, scrolling: $0)
        }
        .task(id: template.previewURL) {
            guard let url = template.previewURL else { return }
            thumbnail = await ThumbnailCache.shared.thumbnail(for: url)
        }
    }
    
    private func updatePlayback(visible: Bool, scrolling: Bool) {
        isPlaying = visible && !scrolling
    }
}

extension VideoTemplateCardView: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.template   == rhs.template   &&
        lhs.isVisible  == rhs.isVisible  &&
        lhs.isScrolling == rhs.isScrolling
    }
}

#Preview {
    VideoTemplateCardView(
        template: .init(
            id: 0,
            title: "template",
            categoryName: "popular",
            availableQualities: [],
            previewURL: Bundle.main.url(forResource: "testVideo", withExtension: "mp4")!
        ),
        isScrolling: false,
        isVisible: true
    )
    .frame(width: 171, height: 232)
    .clipShape(.rect(cornerRadius: 24, style: .continuous))
}
