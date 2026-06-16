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
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.accent)
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
        }
        .frame(maxHeight: .infinity)
        .background(Color.background, ignoresSafeAreaEdges: .all)
        .sheet(isPresented: $viewModel.state.showPhotoPicker) {
            if let slotIndex = viewModel.state.pickingSlotIndex {
                PhotoPickerView { image in
                    viewModel.didPickImage(image, slotIndex: slotIndex)
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
                photoSlotView(slotIndex: slot, templateId: template.id)
            }
            
            Spacer()
        }
    }
    
    @ViewBuilder
    private func photoSlotView(slotIndex: Int, templateId: UUID) -> some View {
        if let image = viewModel.image(for: slotIndex) {
            ImageWithDeleteButton(image: image) {
                viewModel.removeImage(slotIndex: slotIndex)
            }
        } else {
            Button {
                viewModel.tapSlot(index: slotIndex)
            } label: {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(BluePinkGradientStyle(), lineWidth: 1)
                    .frame(width: 100, height: 100)
                    .overlay {
                        Image(systemName: "plus")
                            .font(.title2.weight(.light))
                            .foregroundStyle(.accent)
                    }
            }
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
            viewModel.createTapped()
        } label: {
            Text("Create")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(viewModel.state.isCreateEnabled ? .accent : .accent.opacity(0.3))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(createButtonBackground)
                .clipShape(.rect(cornerRadius: 24, style: .continuous))
                .padding(.horizontal, 16)
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
    let templates = (1...6).map {
        VideoTemplate(title: "Template \($0)", categoryName: "Popular", photoSlotCount: $0 % 2 + 1)
    }
    
    VideoTemplateDetailView(
        viewModel: VideoTemplateDetailViewModel(selected: templates[0], all: templates)
    )
}
