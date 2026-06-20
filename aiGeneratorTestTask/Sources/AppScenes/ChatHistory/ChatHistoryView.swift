import SwiftUI

struct ChatHistoryView: View {
    
    @StateObject var viewModel: ChatHistoryViewModel

    var body: some View {
        VStack(spacing: 24) {
            NavigationBarView {
                Text("AI Chat History")
                    .asNavigationTitle()
            }
            
            if let error = viewModel.state.errorMessage, viewModel.state.chats.isEmpty {
                ErrorView(
                    message: error,
                    retryAction: {
                        Task {
                            await viewModel.load()
                        }
                    },
                    cancelAction: viewModel.dismissError
                )
                .padding(.horizontal, 16)
                .frame(maxHeight: .infinity, alignment: .center)
                .transition(.move(edge: .bottom))
            } else {
                content
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Color.background.ignoresSafeArea())
        .task { await viewModel.load() }
        .animation(.easeOut, value: viewModel.state.errorMessage)
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        if viewModel.state.isLoading && viewModel.state.chats.isEmpty {
            PinkProgressView().largeScale()
        } else if viewModel.state.chats.isEmpty {
            HistoryEmptyView(type: .chat)
                .frame(maxHeight: .infinity, alignment: .center)
        } else {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {
                    ForEach(sections) { section in
                        sectionView(section)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
    }

    // MARK: - Section

    private func sectionView(_ section: ChatSection) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(section.title)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.accent)

            VStack(spacing: 12) {
                ForEach(section.chats) { chat in
                    chatRow(chat)
                }
            }
        }
    }

    private func chatRow(_ chat: ChatSummaryModel) -> some View {
        HStack(spacing: 24) {
            GradientImageView(image: .Images.Common.Icons.sparks, size: 28)
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: 4) {
                Text(chat.lastMessagePreview)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.accent)
                    .lineLimit(1)

                Text(chat.updatedAt.formatted(
                    .dateTime.hour().minute()
                ))
                .font(.system(size: 14))
                .foregroundStyle(.accent.opacity(0.5))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.card.opacity(0.4))
        )
    }

    // MARK: - Date grouping

    private var sections: [ChatSection] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: viewModel.state.chats) { chat in
            calendar.startOfDay(for: chat.updatedAt)
        }
        return grouped.keys
            .sorted(by: >)
            .map { day in
                ChatSection(
                    id: day,
                    title: sectionTitle(for: day),
                    chats: grouped[day]!.sorted { $0.updatedAt > $1.updatedAt }
                )
            }
    }

    private func sectionTitle(for day: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(day) { return "Today" }
        if calendar.isDateInYesterday(day) { return "Yesterday" }
        
        return day.formatted(.dateTime.month(.wide).day())
    }
}

// MARK: - Section model

private struct ChatSection: Identifiable {
    let id: Date
    let title: String
    let chats: [ChatSummaryModel]
}

#Preview {
    InjectedValues.setupForPreviews()
    
    return ChatHistoryView(viewModel: .init())
        .embedRouter()
}
