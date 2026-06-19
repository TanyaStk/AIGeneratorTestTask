//
//  AIChatView.swift
//  aiGeneratorTestTask
//
//

import SwiftUI

struct AIChatView: View {
    
    @StateObject var viewModel: AIChatViewModel
    @EnvironmentObject private var router: AppRouter
    
    @FocusState private var isTextFieldFocused: Bool
    @State private var inputBarHeight: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationBarView {
                titleView
            } rightContent: {
                Button {
                    router.push(.chatHistory)
                } label: {
                    Image(.Images.Common.Icons.reload)
                }
            }
            .background(.card.opacity(0.4))
            
            messageList
                .overlay {
                    if !viewModel.state.hasStarted && viewModel.state.messages.isEmpty {
                        emptyState
                            .frame(maxHeight: .infinity)
                    }
                }
        }
        .frame(maxHeight: .infinity)
        .background(Color.background.ignoresSafeArea())
        .safeAreaInset(edge: .bottom) {
            inputBar
                .onGeometryChange(for: CGFloat.self) { proxy in
                    proxy.size.height
                } action: { newValue in
                    inputBarHeight = newValue
                }
        }
        .animation(.spring, value: viewModel.state.messages)
    }
    
    // MARK: - Nav title
    
    private var titleView: some View {
        HStack(spacing: 12) {
            headerIcon
            
            VStack(alignment: .leading, spacing: 2) {
                Text("AI Chat")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.accent)
                
                Text(Date.now, format: .verbatim("\(day: .twoDigits).\(month: .twoDigits).\(year: .extended())", timeZone: .current, calendar: .current))
                    .font(.system(size: 14))
                    .foregroundStyle(.accent.opacity(0.3))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 72)
    }
    
    private var headerIcon: some View {
        Image(.Images.Common.Icons.sparks)
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(.white)
            .frame(width: 24, height: 24)
            .padding(4)
            .background(
                Circle().fill(BluePinkGradientStyle())
            )
    }
    
    // MARK: - Empty state
    
    private var emptyState: some View {
        VStack(spacing: 8) {
            HStack(spacing: 4) {
                Text("Your").foregroundColor(.accentColor)
                Text("AI assistant").foregroundStyle(BluePinkGradientStyle())
                Text("for anything").foregroundColor(.accent)
            }
            .font(.system(size: 20, weight: .semibold))
            
            Text("Ask questions, get answers, and explore ideas in seconds")
                .font(.system(size: 14))
                .foregroundStyle(.accent.opacity(0.5))
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 23)
    }
    
    // MARK: - Message list
    
    private var messageList: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.state.messages) { message in
                        MessageBubble(message: message)
                            .id(message.id)
                            .transition(.scale.combined(with:
                                    .move(edge: message.role == .user ? .trailing : .leading)
                            ))
                    }
                    
                    if viewModel.state.isSending {
                        TypingIndicator()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Color.clear
                        .frame(height: inputBarHeight + 16)
                        .id(Constants.bottomScrollID)
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 16)
            }
            .onChange(of: viewModel.state.messages.count) { _ in scrollToBottom(proxy) }
            .onChange(of: viewModel.state.isSending) { _ in scrollToBottom(proxy) }
        }
    }
    
    private func scrollToBottom(_ proxy: ScrollViewProxy) {
        withAnimation(.easeOut(duration: 0.25)) {
            proxy.scrollTo(Constants.bottomScrollID, anchor: .bottom)
        }
    }
    
    // MARK: - Input bar
    
    private var inputBar: some View {
        HStack(alignment: .center, spacing: 12) {
            TextField(
                "",
                text: $viewModel.state.inputText,
                prompt: Text(viewModel.state.inputPlaceholder)
                    .foregroundColor(.accent.opacity(0.35)),
                axis: .vertical
            )
            .focused($isTextFieldFocused)
            .foregroundStyle(.accent)
            .padding(.trailing, 24)
            
            if viewModel.state.showSendButton {
                sendButton.transition(.scale.combined(with: .opacity))
            } else {
                trailingIcon.transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.state.showSendButton)
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.card)
                .ignoresSafeArea()
        )
    }
    
    private var sendButton: some View {
        Button {
            viewModel.send()
            isTextFieldFocused.toggle()
        } label: {
            Image(.Images.Common.Icons.send)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .padding(8)
                .background(Circle().fill(BluePinkGradientStyle()))
        }
    }
    
    private var trailingIcon: some View {
        Image(.Images.Common.Icons.import)
            .resizable()
            .scaledToFit()
            .frame(width: 24, height: 24)
            .padding(8)
            .background(
                Circle()
                    .stroke(lineWidth: 1)
                    .fill(.accent.opacity(0.1))
            )
    }
}

private extension AIChatView {
    enum Constants {
        static let bottomScrollID = "bottomScrollID"
    }
}

#Preview {
    InjectedValues.setupForPreviews()
    
    return AIChatView(viewModel: AIChatViewModel())
        .embedRouter()
}
