//
//  LoopingVideoPlayerView.swift
//  aiGeneratorTestTask
//

import SwiftUI
import AVKit

struct LoopingVideoPlayerView: UIViewRepresentable {
    let url: URL?

    func makeUIView(context: Context) -> PlayerUIView {
        let view = PlayerUIView()
        view.configure(with: url)
        return view
    }

    func updateUIView(_ uiView: PlayerUIView, context: Context) {
        uiView.configure(with: url)
    }
}

final class PlayerUIView: UIView {
    
    private var playerLayer: AVPlayerLayer?
    private var player: AVPlayer?
    private var loopObserver: Any?
    private var currentURL: URL?

    override class var layerClass: AnyClass { AVPlayerLayer.self }

    var playerLayerCast: AVPlayerLayer { layer as! AVPlayerLayer }

    func configure(with url: URL?) {
        guard url != currentURL else { return }
        currentURL = url

        cleanup()
        guard let url else { return }

        let player = AVPlayer(url: url)
        player.isMuted = true
        player.allowsExternalPlayback = false

        playerLayerCast.player = player
        playerLayerCast.videoGravity = .resizeAspectFill
        self.player = player

        loopObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { [weak player] _ in
            player?.seek(to: .zero)
            player?.play()
        }

        player.play()
    }

    private func cleanup() {
        player?.pause()
        if let obs = loopObserver {
            NotificationCenter.default.removeObserver(obs)
        }
        playerLayerCast.player = nil
        player = nil
        loopObserver = nil
    }

    deinit { cleanup() }
}
