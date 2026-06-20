//
//  VideoResultView.swift
//  aiGeneratorTestTask
//
//

import SwiftUI
import Photos

struct VideoResultView: View {
    
    var result: Result<VideoGenerationResponse, VideoGenerationError>
    
    let onReplace: () -> ()
    let onCancel: (() -> ())?
    
    @Injected(\.photoLibraryService) private var photoLibraryService
    
    @State private var state = ViewState()
    
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
                ErrorView(
                    message: failure.userFacingMessage,
                    retryAction: onReplace,
                    cancelAction: {
                        onCancel?()
                    })
                .padding(.bottom, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 16)
        .alert("Saved to Photos", isPresented: $state.showDownloadConfirmation) { // TODO: - Replace on custom view
            Button("OK", role: .cancel) {}
        }
        .alert("Photos Access Needed", isPresented: $state.showPermissionAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
        } message: {
            Text("Allow access to your photo library in Settings to save this video.")
        }
        .alert("Couldn't Save Video", isPresented: $state.showSaveError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(state.saveErrorMessage)
        }
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
                Group {
                    if state.isSaving {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Download")
                    }
                }
                .asGradientButton()
            }
            .disabled(state.isSaving)
        }
    }
}

private extension VideoResultView {
    
    func shareVideo() {
        guard case .success(let result) = result,
              let url = result.videoURL else { return }
        
        let av = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first?
            .rootViewController?
            .present(av, animated: true)
    }
    
    func downloadVideo() {
        guard case .success(let success) = result,
              let url = success.videoURL else { return }
        
        Task {
            await handleDownload(url: url)
        }
    }
    
    @MainActor
    func handleDownload(url: URL) async {
        state.isSaving = true
        defer { state.isSaving = false }
        
        let currentStatus = photoLibraryService.authorizationStatus()
        let status: PHAuthorizationStatus
        
        if currentStatus == .notDetermined {
            status = await photoLibraryService.requestAuthorization()
        } else {
            status = currentStatus
        }
        
        switch status {
        case .authorized, .limited:
            do {
                try await photoLibraryService.saveVideo(at: url)
                state.showDownloadConfirmation = true
            } catch {
                state.saveErrorMessage = error.localizedDescription
                state.showSaveError = true
            }
            
        case .denied, .restricted:
            state.showPermissionAlert = true
            
        case .notDetermined:
            break
            
        @unknown default:
            break
        }
    }
}

// MARK: - ViewState

private extension VideoResultView {
    struct ViewState {
        var showDownloadConfirmation = false
        var isSaving = false
        var showPermissionAlert = false
        var showSaveError = false
        var saveErrorMessage = ""
    }
}

#Preview("Success") {
    VStack {
        NavigationBarView {
            Text("Result")
                .asNavigationTitle()
        }
        
        VideoResultView(
            result: .success(VideoGenerationResponse(
                id: 0,
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
