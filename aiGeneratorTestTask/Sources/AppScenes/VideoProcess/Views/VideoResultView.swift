//
//  VideoResultView.swift
//  aiGeneratorTestTask
//
//

import SwiftUI

struct VideoResultView: View {
    var result: VideoGenerationResult? = nil
    var error: VideoGenerationError? = nil
    let onReplace: () -> Void

    @State private var showDownloadConfirmation = false

    var body: some View {
        VStack(spacing: 0) {
            videoArea
                .padding(.top, 8)

            Spacer()

            if let error {
                errorBanner(error)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
            } else {
                actionBar
                    .padding(.horizontal, 16)
                    .padding(.bottom, 32)
            }
        }
    }

    // MARK: - Video / error area

    private var videoArea: some View {
        ZStack(alignment: .topTrailing) {
            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color(white: 0.10))

                if error != nil {
                    // Error state — show icon instead of video
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(.orange)
                        Text("Generation failed")
                            .font(.headline)
                            .foregroundStyle(.white)
                    }
                } else {
                    // Success state — video placeholder with play button
                    // Replace this ZStack with a real AVPlayer view when wiring up
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [Color(white: 0.22), Color(white: 0.06)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        Image(systemName: "play.fill")
                            .font(.system(size: 44))
                            .foregroundStyle(.white.opacity(0.85))
                            .padding(24)
                            .background(Circle().fill(Color.white.opacity(0.15)))
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 420)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .padding(.horizontal, 16)

            // Replace button (only on success)
            if error == nil {
                replaceButton
                    .padding(.top, 12)
                    .padding(.trailing, 28)
            }
        }
    }

    private var replaceButton: some View {
        Button(action: onReplace) {
            HStack(spacing: 6) {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .font(.caption.weight(.semibold))
                Text("Replace")
                    .font(.subheadline.weight(.semibold))
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(Color(white: 0.18).opacity(0.9))
            )
        }
    }

    // MARK: - Action bar (success)

    private var actionBar: some View {
        HStack(spacing: 12) {
            Button {
                shareVideo()
            } label: {
                Text("Share")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(Color(white: 0.14))
                    )
            }

            Button {
                downloadVideo()
            } label: {
                Text("Download")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.65, green: 0.78, blue: 0.95),
                                        Color(red: 0.95, green: 0.55, blue: 0.75)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
            }
        }
        .alert("Saved to Photos", isPresented: $showDownloadConfirmation) {
            Button("OK", role: .cancel) {}
        }
    }

    // MARK: - Error banner (failure)

    private func errorBanner(_ error: VideoGenerationError) -> some View {
        VStack(spacing: 16) {
            Text(error.errorDescription ?? "Unknown error")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)

            Button(action: onReplace) {
                Text("Try Again")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.65, green: 0.78, blue: 0.95),
                                        Color(red: 0.95, green: 0.55, blue: 0.75)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(white: 0.10))
        )
    }

    // MARK: - Actions

    private func shareVideo() {
        guard let urlString = result?.videoURL,
              let url = URL(string: urlString) else { return }
        
        let av = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first?
            .rootViewController?
            .present(av, animated: true)
    }

    private func downloadVideo() {
        // Wire up real PHPhotoLibrary save here
        showDownloadConfirmation = true
    }
}

#Preview("Success") {
    ZStack {
        Color.black.ignoresSafeArea()
        
        VideoResultView(
            result: VideoGenerationResult(templateTitle: "Clay Fool", videoURL: ""),
            onReplace: {}
        )
    }
    .preferredColorScheme(.dark)
}

#Preview("Error") {
    ZStack {
        Color.black.ignoresSafeArea()
        
        VideoResultView(error: .serverError(code: 500), onReplace: {})
    }
    .preferredColorScheme(.dark)
}
