import SwiftUI
import VideoPlayer
import Combine

struct VideoTemplatesLibraryView: View {
    
    @StateObject var viewModel: VideoTemplatesLibraryViewModel
    @EnvironmentObject private var router: AppRouter
    
    @State private var appearedIDs: [Int] = []
    @State private var playingIDs: Set<Int> = []
    
    @State private var isScrolling = false
    @State private var scrollCancellable: AnyCancellable?
    
    private let maxPlayers = 4
    
    private let columns = [GridItem(.flexible(), spacing: 16),
                           GridItem(.flexible(), spacing: 16)]
    
    var body: some View {
        VStack(spacing: 24) {
            navigationBar
            
            if let error = viewModel.state.errorMessage {
                ErrorView(
                    message: error,
                    retryAction: viewModel.retry,
                    cancelAction: viewModel.dismissError
                )
                .padding(.horizontal, 16)
                .frame(maxHeight: .infinity, alignment: .center)
                .transition(.move(edge: .bottom))
            } else {
                categoryBar
                content
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Color.background.ignoresSafeArea())
        .task { await viewModel.onAppear() }
        .animation(.easeOut, value: viewModel.state.errorMessage)
        .onDisappear {
            clearCache()
        }
        .onReceive(
            NotificationCenter.default.publisher(for: UIApplication.didReceiveMemoryWarningNotification)
        ) { _ in clearCache() }
    }
    
    // MARK: - Navigation bar
    
    private var navigationBar: some View {
        NavigationBarView {
            titleView
        } rightContent: {
            Button { router.push(.videoHistory) } label: {
                Image(.Images.Common.Icons.reload)
            }
        }
        .background(.card.opacity(0.4))
    }
    
    private var titleView: some View {
        HStack(spacing: 12) {
            Image(.Images.Common.Icons.imageToVideo)
                .resizable()
                .frame(width: 24, height: 24)
                .padding(4)
                .background(Circle().fill(BluePinkGradientStyle()))
            
            Text("AI Video")
                .asNavigationTitle()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 72)
    }
    
    // MARK: - Category bar
    
    private var categoryBar: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.state.categories) { category in
                        CategoryPillView(
                            category: category,
                            isSelected: category == viewModel.state.selectedCategory
                        )
                        .id(category.id)
                        .onTapGesture {
                            withAnimation {
                                viewModel.select(category: category)
                                proxy.scrollTo(category.id, anchor: .center)
                            }
                            
                            clearCache()
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    // MARK: - Content
    
    @ViewBuilder
    private var content: some View {
        if viewModel.state.isLoading && viewModel.state.templates.isEmpty {
            PinkProgressView().largeScale()
        } else {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.state.templates) { template in
                        VideoTemplateCardView(
                            template: template,
                            isScrolling: isScrolling,
                            isVisible: playingIDs.contains(template.id)
                        )
                        .equatable()
                        .frame(maxWidth: 170)
                        .frame(height: 232)
                        .clipShape(.rect(cornerRadius: 24, style: .continuous))
                        .onAppear  {
                            cellAppeared(id: template.id, template: template)
                        }
                        .onDisappear {
                            cellDisappeared(id: template.id)
                        }
                        .onTapGesture {
                            router.push(.templateDetail(
                                selected: template,
                                all: viewModel.state.templates
                            ))
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            .background(
                ScrollOffsetReader { _ in handleScroll() }
            )
        }
    }
}

private extension VideoTemplatesLibraryView {
    func cellAppeared(id: Int, template: VideoTemplate) {
        guard !appearedIDs.contains(id) else { return }
        
        appearedIDs.append(id)
        recomputePlayingIDs()
    }
    
    func cellDisappeared(id: Int) {
        appearedIDs.removeAll { $0 == id }
        recomputePlayingIDs()
    }
    
    func recomputePlayingIDs() {
        let templates = viewModel.state.templates
        let sorted = appearedIDs.sorted { first, second in
            (templates.firstIndex { $0.id == first } ?? .max)
            < (templates.firstIndex { $0.id == second } ?? .max)
        }
        
        playingIDs = Set(sorted.prefix(maxPlayers))
    }
    
    func handleScroll() {
        isScrolling = true
        scrollCancellable?.cancel()
        scrollCancellable = Just(())
            .delay(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .sink { _ in isScrolling = false }
    }
    
    func clearCache() {
        appearedIDs.removeAll()
        playingIDs.removeAll()
        
        VideoPlayer.cleanAllCache()
        ThumbnailCache.shared.clear()
    }
}

#Preview {
    InjectedValues.setupForPreviews()
    
    return VideoTemplatesLibraryView(viewModel: VideoTemplatesLibraryViewModel())
        .embedRouter()
}
