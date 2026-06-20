//
//  VideoTemplateDetailView.swift
//  aiGeneratorTestTask
//

import SwiftUI

struct VideoTemplateDetailView: View {
    
    @StateObject var viewModel: VideoTemplateDetailViewModel
    
    @EnvironmentObject private var router: AppRouter
    
    var body: some View {
        VStack(spacing: 8) {
            NavigationBarView {
                Text(viewModel.state.currentTemplate.title)
                    .asNavigationTitle()
            }
            
            TabView(selection: $viewModel.state.currentIndex) {
                ForEach(viewModel.state.templates.indices, id: \.self) { index in
                    templatePreview(viewModel.state.currentTemplate)
                        .frame(maxHeight: .infinity, alignment: .top)
                        .tag(index)
                        .padding(.horizontal, 16)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onChange(of: viewModel.state.currentIndex) { _ in
                viewModel.onTemplateChanged()
            }
            
            createButton
                .padding(.bottom, 16)
                .padding(.horizontal, 16)
        }
        .frame(maxHeight: .infinity)
        .background(Color.background, ignoresSafeAreaEdges: .all)
        .sheet(isPresented: $viewModel.state.showPhotoPicker) {
            if let slotIndex = viewModel.state.pickingSlotIndex {
                PhotoPickerView { image in
                    viewModel.didPickImage(image, slotIndex: slotIndex)
                }
                .onAppear {
                    viewModel.didStartPicking(slotIndex: slotIndex)
                }
            }
        }
    }
    
    private func templatePreview(_ template: VideoTemplate) -> some View {
        VStack(spacing: 24) {
            templateVideo
                .frame(maxHeight: 312)
            
            photoSlotsSection(viewModel.state.currentTemplate)
            settingsSection
        }
    }
    
    @ViewBuilder
    private var templateVideo: some View {
        if let url = viewModel.state.currentTemplateDownloadedURL {
            LoopingVideoPlayerView(url: url)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        } else if viewModel.state.shouldShowRetryLoadingVideo {
            ReplaceButton(title: "Reload", onReplace: viewModel.reloadTemplate)
        } else {
            PinkProgressView()
        }
    }
    
    private func photoSlotsSection(_ template: VideoTemplate) -> some View {
        HStack(spacing: 24) {
            ForEach(0..<template.photoSlotCount, id: \.self) { slot in
                PhotoSlotStateView(state: viewModel.slotState(for: slot))
            }
            
            Spacer()
        }
    }
    
    private var settingsSection: some View {
        VStack(spacing: 8) {
            settingsRow(
                label: "Format",
                value: viewModel.state.selectedFormat,
                options: VideoTemplateDetailViewModel.VideoFormat.allCases.map { $0.rawValue },
                selection: $viewModel.state.selectedFormat
            )
            
            settingsRow(
                label: "Quality",
                value: viewModel.state.selectedQuality,
                options: viewModel.state.currentTemplate.availableQualities,
                selection: $viewModel.state.selectedQuality
            )
        }
    }
    
    private var createButton: some View {
        Button {
            generateVideoOrShowPaywall()
        } label: {
            Text("Create")
                .asGradientButton(viewModel.state.isCreateEnabled)
        }
        .disabled(!viewModel.state.isCreateEnabled)
    }
    
    @ViewBuilder
    private var createButtonBackground: some View {
        if viewModel.state.isCreateEnabled {
            BluePinkGradientView()
        } else {
            Color.card
        }
    }
}

// MARK: - Paid logic

private extension VideoTemplateDetailView {
    func generateVideoOrShowPaywall() {
        if viewModel.userHasPremium {
            if let request = viewModel.setupRequest() {
                router.push(.videoProcess(request: request))
            }
        } else {
            router.togglePaywallVisibility()
        }
    }
}

#Preview {
    InjectedValues.setupForPreviews()
    
    let templates = (1...6).map {
        VideoTemplate(
            id: $0,
            title: "Template \($0)",
            categoryName: "category of template \($0)",
            photoSlotCount: 1,
            availableQualities: ["480", "4k"],
            previewURL: Bundle.main.url(forResource: "testVideo", withExtension: "mp4")!
        )
    }
    
    return VideoTemplateDetailView(
        viewModel: VideoTemplateDetailViewModel(selected: templates[0], all: templates)
    )
    .embedRouter()
}
