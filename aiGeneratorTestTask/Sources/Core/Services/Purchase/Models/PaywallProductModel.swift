//
//  PaywallProductModel.swift
//  aiGeneratorTestTask
//

import Foundation

struct PaywallProductModel: Identifiable {
    let id: String
    let price: String
    let priceFormat: String
    let weeksInPeriodAmount: Double
    let pricePeriod: String
}

extension PaywallProductModel {
    
    static let fallback = Self(
        id: "fallback.appstore.product.identifier",
        price: "",
        priceFormat: "",
        weeksInPeriodAmount: 0,
        pricePeriod: ""
    )
}
