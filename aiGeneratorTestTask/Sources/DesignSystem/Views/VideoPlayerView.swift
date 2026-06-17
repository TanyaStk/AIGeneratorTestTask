//
//  VideoPlayerView.swift
//  aiGeneratorTestTask
//


import SwiftUI
import AVKit

struct VideoPlayerView: UIViewControllerRepresentable {
    
    let player: AVPlayer

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let vc = AVPlayerViewController()
        vc.player = player
        vc.showsPlaybackControls = true
        vc.videoGravity = .resizeAspect
        
        return vc
    }

    func updateUIViewController(_ vc: AVPlayerViewController, context: Context) {}
}
