//
//  VideoPlayerView.swift
//  aiGeneratorTestTask
//


import SwiftUI
import AVKit

struct VideoPlayerView: UIViewControllerRepresentable {
    
    let url: URL
    
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let player = AVPlayer(url: url)
        let vc = AVPlayerViewController()
        vc.player = player
        vc.videoGravity = .resizeAspect
        vc.delegate = context.coordinator
        player.play()
        return vc
    }
    
    func updateUIViewController(_ vc: AVPlayerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator { Coordinator(dismiss: dismiss) }
    
    final class Coordinator: NSObject, AVPlayerViewControllerDelegate {
        
        let dismiss: DismissAction
        
        init(dismiss: DismissAction) {
            self.dismiss = dismiss
        }
        
        func playerViewController(
            _ playerViewController: AVPlayerViewController,
            willBeginFullScreenPresentationWithAnimationCoordinator coordinator: UIViewControllerTransitionCoordinator
        ) {}
        
        func playerViewController(
            _ playerViewController: AVPlayerViewController,
            willEndFullScreenPresentationWithAnimationCoordinator coordinator: UIViewControllerTransitionCoordinator
        ) {
            coordinator.animate(alongsideTransition: nil) { _ in
                self.dismiss()
            }
        }
    }
}
