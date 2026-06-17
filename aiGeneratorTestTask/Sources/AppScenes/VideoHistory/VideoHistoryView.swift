//
//  VideoHistoryView.swift
//  aiGeneratorTestTask
//

import SwiftUI

struct VideoHistoryView: View {
    
    @StateObject var viewModel: VideoHistoryViewModel
    
    private let spacing: CGFloat = 8
    
    var body: some View {
        VStack {
            NavigationBarView {
                Text("AI Video History")
                    .asNavigationTitle()
            }
            
            historyContent
        }
        .background(Color.background)
    }
    
    @ViewBuilder
    private var historyContent: some View {
        if viewModel.state.items.isEmpty {
            HistoryEmptyView(type: .video)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    Image(.Images.History.videoGallery)
                        .resizable()
                        .overlay {
                            Image(.Images.History.gradientBackground)
                                .resizable()
                                .scaledToFill()
                                .ignoresSafeArea()
                        }
                )
        } else {
            let columns = splitIntoColumns(viewModel.state.items)
            
            ScrollView(showsIndicators: false) {
                HStack(alignment: .top, spacing: spacing) {
                    LazyVStack(spacing: spacing) {
                        ForEach(columns.left) { item in
                            thumbnailCard(item)
                        }
                    }
                    
                    LazyVStack(spacing: spacing) {
                        ForEach(columns.right) { item in
                            thumbnailCard(item)
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
            }
        }
    }
    
    private func splitIntoColumns(_ items: [VideoHistoryItemModel]) -> (
        left: [VideoHistoryItemModel],
        right: [VideoHistoryItemModel]
    ) {
        var left: [VideoHistoryItemModel] = []
        var right: [VideoHistoryItemModel] = []
        
        var leftHeight: CGFloat = 0
        var rightHeight: CGFloat = 0
        
        let columnWidth = (UIScreen.main.bounds.width - 24 - 8) / 2
        
        for item in items {
            let estimatedHeight: CGFloat
            
            if let image = viewModel.state.thumbnails[item.id] {
                estimatedHeight = columnWidth * image.size.height / image.size.width
            } else {
                estimatedHeight = 200
            }
            
            if leftHeight <= rightHeight {
                left.append(item)
                leftHeight += estimatedHeight
            } else {
                right.append(item)
                rightHeight += estimatedHeight
            }
        }
        
        return (left, right)
    }
    
    @ViewBuilder
    private func thumbnailCard(_ item: VideoHistoryItemModel) -> some View {
        if let image = viewModel.state.thumbnails[item.id] {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .clipShape(.rect(cornerRadius: 16, style: .continuous))
        } else {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.card.opacity(0.6))
                .frame(height: 200)
        }
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    InjectedValues[\.videoHistoryRepository] = MockVideoHistoryRepository()
    
    return VideoHistoryView(viewModel: .init())
}
