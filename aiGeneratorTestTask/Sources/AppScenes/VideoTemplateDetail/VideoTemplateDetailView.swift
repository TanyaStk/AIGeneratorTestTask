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
            templateImage
            photoSlotsSection(viewModel.state.currentTemplate)
            settingsSection
        }
    }
    
    private var templateImage: some View {
        Image(.Images.VideoGeneration.templateMock)
            .resizable()
            .scaledToFill()
            .frame(maxHeight: 312)
            .clipShape(.rect(cornerRadius: 16, style: .continuous))
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
                options: viewModel.state.currentTemplate.availableFormats,
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
            let request = viewModel.setupRequest()
            router.push(.videoProcess(request: request))
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

#Preview {
    InjectedValues.setupForPreviews()
    
    let templates = (1...6).map {
        VideoTemplate(title: "Template \($0)", categoryName: "Popular", photoSlotCount: $0 % 2 + 1)
    }
    
    return VideoTemplateDetailView(
        viewModel: VideoTemplateDetailViewModel(selected: templates[0], all: templates)
    )
    .embedRouter()
}
