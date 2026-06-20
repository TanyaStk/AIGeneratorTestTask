//
//  VideoProcessView.swift
//  aiGeneratorTestTask
//

import SwiftUI

struct VideoProcessView: View {
    
    @StateObject var viewModel: VideoProcessViewModel
    
    @EnvironmentObject private var router: AppRouter
    @State private var shouldConfirmDownloading: Bool = false
    
    var body: some View {
        VStack {
            NavigationBarView {
                Text(titleForState)
                    .asNavigationTitle()
            }

            bodyView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.background)
        .overlay {
            if shouldConfirmDownloading {
                Color.black.opacity(0.6)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        dismissDownloadConfirmation()
                    }
                
                VideoSavedConfirmationView()
                    .frame(maxHeight: .infinity, alignment: .center)
                    .ignoresSafeArea()
                    .transition(.move(edge: .bottom))
            }
        }
        .animation(.linear, value: shouldConfirmDownloading)
        .animation(.linear, value: viewModel.state)
        .task(id: viewModel.retryToken) {
            await viewModel.startGeneration()
        }
        .onChange(of: shouldConfirmDownloading) { newValue in
            if newValue {
                delayDownloadConfirmation()
            }
        }
    }
    
    @ViewBuilder
    private var bodyView: some View {
        switch viewModel.state {
        case .generating:
            GeneratingView()
        case .result(let result):
            VideoResultView(
                shouldConfirmDownloading: $shouldConfirmDownloading,
                result: result,
                onReplace: viewModel.retry,
                onCancel: router.popToRoot
            )
            .transition(.move(edge: .bottom))
        }
    }
    
    private var titleForState: String {
        switch viewModel.state {
        case .generating:
            ""
        case .result:
            "Result"
        }
    }
}


private extension VideoProcessView {
    func dismissDownloadConfirmation() {
        shouldConfirmDownloading = false
    }
    
    func delayDownloadConfirmation() {
        Task {
            try? await Task.sleep(for: .seconds(2))
            
            dismissDownloadConfirmation()
        }
    }
}

#Preview {
    InjectedValues.setupForPreviews()
    
    return VideoProcessView(viewModel: .init(
        request: .init(
            templateId: 0,
            templateTitle: "template",
            photoSlotCount: 1,
            image: nil,
            duration: 0,
            quality: ""
        )
    ))
    .embedRouter()
}
