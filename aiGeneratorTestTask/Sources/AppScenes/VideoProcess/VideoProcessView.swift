//
//  VideoProcessView.swift
//  aiGeneratorTestTask
//

import SwiftUI

struct VideoProcessView: View {
    
    @StateObject var viewModel: VideoProcessViewModel
    
    @EnvironmentObject private var router: AppRouter
    
    var body: some View {
        VStack {
            NavigationBarView {
                Text(titleForState)
                    .asNavigationTitle()
            }
            
            bodyView
        }
        .frame(maxWidth: .infinity)
        .background(Color.background)
        .animation(.linear, value: viewModel.state)
        .task(id: viewModel.retryToken) {
            await viewModel.startGeneration()
        }
    }
    
    @ViewBuilder
    private var bodyView: some View {
        switch viewModel.state {
        case .generating:
            GeneratingView()
        case .result(let result):
            VideoResultView(
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

#Preview {
    VideoProcessView(viewModel: VideoProcessViewModel(
        request: .init(templateId: UUID(), templateTitle: "Template", photoSlotCount: 1),
        service: MockVideoGenerationService())
    )
    .embedRouter()
}
