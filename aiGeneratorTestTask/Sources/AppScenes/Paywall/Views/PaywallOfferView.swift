//
//  PaywallOfferView.swift
//  aiGeneratorTestTask
//
//

import SwiftUI

extension PaywallView {
    
    struct OfferView: View {
        var body: some View {
            VStack(spacing: 32) {
                titleText
                
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(OfferCase.allCases) { offer in
                        row(for: offer)
                    }
                }
            }
        }
        
        private var titleText: some View {
            Text("Create anything\nyou want")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(.accent)
                .multilineTextAlignment(.center)
        }
        
        private func row(for offer: OfferCase) -> some View {
            HStack(spacing: 8) {
                GradientImageView(image: offer.icon, size: 24)
                
                Text(offer.description)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.accent)
                    .padding(.vertical, 6)
            }
        }
    }
}

private extension PaywallView.OfferView {
    enum OfferCase: CaseIterable, Identifiable {
        case fastResults
        case betterWriting
        case simplifyInfo
        case aiContent
        
        var id: OfferCase { self }
        
        var icon: ImageResource {
            switch self {
            case .fastResults:
                    .Images.Common.Icons.sparks
            case .betterWriting:
                    .Images.Common.Icons.magicPencil
            case .simplifyInfo:
                    .Images.Common.Icons.letterIWithSparks
            case .aiContent:
                    .Images.Common.Icons.imageToVideo
            }
        }
        
        var description: String {
            switch self {
            case .fastResults:
                "Get results in seconds"
            case .betterWriting:
                "Turn any text into better writing"
            case .simplifyInfo:
                "Simplify complex information"
            case .aiContent:
                "Create content with AI templates"
            }
        }
    }
}

#Preview {
    PaywallView.OfferView()
        .background(.black)
}
