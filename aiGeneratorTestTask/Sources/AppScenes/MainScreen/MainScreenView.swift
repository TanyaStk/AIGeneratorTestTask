//
//  MainScreenView.swift
//  aiGeneratorTestTask
//
//

import SwiftUI

struct MainScreenView: View {
    
    @StateObject var viewModel: MainScreenViewModel
    
    @EnvironmentObject var router: AppRouter
    
    var body: some View {
        VStack(spacing: 24) {
            settingsButton
            headerSection
            toolsSection
        }
        .padding(16)
        .padding(.bottom, 80)
        .background(backgroundImage)
    }
    
    private var backgroundImage: some View {
        Image(.Images.MainScreen.background)
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var settingsButton: some View {
        Button {
            router.push(.settings)
        } label: {
            Image(.Images.Common.Icons.settings)
                .resizable()
                .frame(width: 28, height: 28)
                .opacity(0.3)
                .padding(8)
                .background(Circle().fill(Color.card.opacity(0.4)))
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 24) {
            Image(.Images.MainScreen.screenHeaderIcon)
                .resizable()
                .frame(width: 60, height: 60)
                .scaledToFit()
            
            Text("Your AI tools,\nready to go")
                .font(.system(size: 28, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundStyle(.accent)
            
            Button {
                router.push(.aiChat)
            } label: {
                promptButtonLabel
            }
            
        }
        .padding(.bottom, 16)
    }
    
    private var promptButtonLabel: some View {
        HStack(spacing: 10) {
            Image(.Images.Common.Icons.sparks)
                .resizable()
                .frame(width: 24, height: 24)
                .scaledToFit()
                .foregroundStyle(.accent)
            
            Text("Ask anything...")
                .foregroundColor(.accent.opacity(0.5))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.card.opacity(0.7))
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .strokeBorder(BluePinkGradientStyle())
                        .opacity(0.5)
                )
        )
    }
    
    private var toolsSection: some View {
        HStack(alignment: .top, spacing: 12) {
            MainScreenFeatureView(tool: .photoToVideo) {
                showVideoGenerationOrPaywall()
            }
            
            VStack(spacing: 12) {
                AITextToolCardView(tool: .rewriteText) {
                    showChatOrPaywall()
                }
                
                AITextToolCardView(tool: .summarizeText) {
                    showChatOrPaywall()
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

private extension MainScreenView {
    func showChatOrPaywall() {
        if viewModel.userHasPremium {
            router.push(.aiChat)
        } else {
            router.togglePaywallVisibility()
        }
    }
    
    func showVideoGenerationOrPaywall() {
        if viewModel.userHasPremium {
            router.push(.photoToVideoGeneration)
        } else {
            router.togglePaywallVisibility()
        }
    }
}

#Preview {
    MainScreenView(viewModel: .init())
        .embedRouter()
}
