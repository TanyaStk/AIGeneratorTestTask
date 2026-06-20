//
//  VideoTemplatesLibraryView.swift
//  aiGeneratorTestTask
//

import SwiftUI

struct VideoTemplatesLibraryView: View {
    
    @StateObject var viewModel: VideoTemplatesLibraryViewModel
    
    @EnvironmentObject private var router: AppRouter
    
    private let columns = [GridItem(.flexible(), spacing: 16),
                           GridItem(.flexible(), spacing: 16)]
    
    var body: some View {
        VStack(spacing: 24) {
            NavigationBarView {
                titleView
            } rightContent: {
                Button {
                    router.push(.videoHistory)
                } label: {
                    Image(.Images.Common.Icons.reload)
                }
            }
            .background(.card.opacity(0.4))
            
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
        .background(
            Color.background.ignoresSafeArea()
        )
        .task {
            await viewModel.onAppear()
        }
        .animation(.easeOut, value: viewModel.state.errorMessage)
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
                        VideoTemplateCardView(template: template)
                            .onTapGesture {
                                router.push(.templateDetail(selected: template, all: viewModel.state.templates))
                            }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
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
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    // MARK: - Toolbar title
    
    private var titleView: some View {
        HStack(spacing: 12) {
            Image(.Images.Common.Icons.imageToVideo)
                .resizable()
                .frame(width: 24, height: 24)
                .padding(4)
                .background(
                    Circle().fill(BluePinkGradientStyle())
                )
            
            Text("AI Video")
                .asNavigationTitle()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 72)
    }
}

#Preview {
    InjectedValues.setupForPreviews()
    
    return VideoTemplatesLibraryView(viewModel: VideoTemplatesLibraryViewModel())
        .embedRouter()
}
