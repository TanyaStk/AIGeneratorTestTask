import SwiftUI

struct VideoProcessView: View {
    @StateObject var viewModel: VideoProcessViewModel
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            switch viewModel.state {
            case .generating:
                GeneratingView()
            case .success(let result):
                ResultView(result: result, onReplace: { viewModel.retry() })
            case .failure(let error):
                ResultView(error: error, onReplace: { viewModel.retry() })
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(titleForState)
        .navigationBarBackButtonHidden(false)
        .toolbarBackground(Color.black, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .task { await viewModel.startGeneration() }
    }

    private var titleForState: String {
        switch viewModel.state {
        case .generating: return ""
        case .success, .failure: return "Result"
        }
    }
}