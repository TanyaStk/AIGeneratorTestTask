//
//  PriceView.swift
//  aiGeneratorTestTask
//

import SwiftUI

struct PriceView: View {
    
    let product: PaywallDisplayProductModel
    
    var isSelected: Bool
    
    var body: some View {
        HStack(alignment: .top) {
            priceStack
            
            Spacer()
            
            if let saleAmount = product.saleAmount, saleAmount > 0 {
                saleLabel(saleAmount)
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity)
        .background(border)
    }
    
    private var priceStack: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(Text(product.perWeekPrice.capitalized).font(.system(size: 16, weight: .medium))) \(Text(product.perWeekString).font(.system(size: 16, weight: .regular)))")
                .foregroundStyle(.accent)
            
            Text(product.totalPrice)
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(.paywallGrey)
        }
    }
    
    private func saleLabel(_ amount: Int) -> some View {
        Text("SAVE \(amount)%")
            .font(.system(size: 14, weight: .medium))
            .foregroundStyle(.accent)
            .padding(.vertical, 6)
            .padding(.horizontal, 16)
            .background(
                BluePinkGradientView()
                    .clipShape(.capsule)
            )
    }
    
    @ViewBuilder
    private var border: some View {
        if isSelected {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(lineWidth: 1)
                .foregroundStyle(BluePinkGradientStyle())
        } else {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(lineWidth: 1)
                .foregroundStyle(Color.paywallGrey)
        }
    }
}

#Preview {
    VStack {
        PriceView(product: .init(
            id: "product.id",
            perWeekPrice: "year $1.27",
            perWeekString: "/ week",
            totalPrice: "$ 69.99",
            saleAmount: 80
        ), isSelected: false)
        
        PriceView(product: .init(
            id: "product.id",
            perWeekPrice: "year $1.27",
            perWeekString: "/ week",
            totalPrice: "$ 69.99",
            saleAmount: nil
        ), isSelected: true)
    }
    .background(.black)
}
