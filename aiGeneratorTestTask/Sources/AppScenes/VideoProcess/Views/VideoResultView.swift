//
//  VideoResultView.swift
//  aiGeneratorTestTask
//
//

import SwiftUI

struct VideoResultView: View {
    
    var result: Result<VideoGenerationResult, VideoGenerationError>
    
    let onReplace: () -> ()
    let onCancel: (() -> ())?
    
    @State private var showDownloadConfirmation = false
    
    var body: some View {
        VStack(spacing: 16) {
            switch result {
            case .success(let success):
                VideoPreviewView(url: success.videoURL)
                    .overlay(alignment: .topTrailing) {
                        replaceButton
                    }
                actionBar
                
            case .failure(let failure):
                ErrorView(error: failure, retryAction: onReplace, cancelAction: {
                    onCancel?()
                })
                .padding(.bottom, 40)
            }
        }
        .padding(.horizontal, 16)
        .frame(maxHeight: .infinity)
    }
    
    private var replaceButton: some View {
        Button(action: onReplace) {
            HStack(spacing: 6) {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .font(.subheadline.weight(.bold))
                
                Text("Replace")
                    .font(.system(size: 14, weight: .regular))
            }
            .foregroundStyle(.accent)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(Color.card.opacity(0.4))
            )
            .padding(.top, 16)
            .padding(.trailing, 16)
        }
    }
    
    private var actionBar: some View {
        HStack(spacing: 16) {
            Button {
                shareVideo()
            } label: {
                Text("Share")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.accent)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color.card.opacity(0.6))
                    )
            }
            
            Button {
                downloadVideo()
            } label: {
                Text("Download")
                    .asGradientButton()
            }
        }
        .alert("Saved to Photos", isPresented: $showDownloadConfirmation) { // TODO: - Replace on custom view
            Button("OK", role: .cancel) {
                
            }
        }
    }
    
    private func shareVideo() {
        guard case .success(let result) = result else { return }
        
        let av = UIActivityViewController(activityItems: [result.videoURL], applicationActivities: nil)
        
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first?
            .rootViewController?
            .present(av, animated: true)
    }
    
    private func downloadVideo() { // TODO: - Handle download and show permission on write
        showDownloadConfirmation = true
    }
}

// MARK: - Error View

private extension VideoResultView {
    struct ErrorView: View {
        
        let error: VideoGenerationError
        
        var retryAction: () -> ()
        var cancelAction: () -> ()
        
        var body: some View {
            VStack(spacing: 16) {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(.lightPink)
                    
                    Text("Generation failed")
                        .font(.headline)
                        .foregroundStyle(.white)
                }
                
                Text(error.errorDescription ?? "Unknown error")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                
                VStack(spacing: 8) {
                    Button(action: retryAction) {
                        Text("Try Again")
                            .asGradientButton()
                    }
                    
                    Button(action: cancelAction) {
                        Text("Cancel")
                            .asCardButton()
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.card)
            )
        }
    }
}

#Preview("Success") {
    VStack {
        NavigationBarView {
            Text("Result")
                .asNavigationTitle()
        }
        
        VideoResultView(
            result: .success(VideoGenerationResult(
                templateTitle: "Clay Fool",
                videoURL: URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_4x3/bipbop_4x3_variant.m3u8")!)),
            onReplace: {},
            onCancel: {}
        )
    }
    .background(Color.background)
}

#Preview("Error") {
    VStack {
        NavigationBarView { Text("Result") }
        
        VideoResultView(
            result: .failure(.serverError(code: 500)),
            onReplace: {},
            onCancel: {}
        )
    }
    .background(.blue)
}
