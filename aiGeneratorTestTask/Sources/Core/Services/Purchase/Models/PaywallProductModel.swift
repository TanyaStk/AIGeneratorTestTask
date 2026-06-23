//
//  PaywallProductModel.swift
//  aiGeneratorTestTask
//

import Foundation

struct PaywallProductModel: Identifiable {
    let id: String
    let displayPrice: String
    let pricePerWeek: Decimal
    let pricePerWeekFormatted: String
    let pricePeriod: String
}

extension PaywallProductModel {
    
    static let fallback = Self(
        id: "fallback.appstore.product.identifier",
        displayPrice: "",
        pricePerWeek: 0,
        pricePerWeekFormatted: "",
        pricePeriod: ""
    )
    
    static let testYearly = Self(
        id: "testYearly.fallback.appstore.product.identifier",
        displayPrice: "69.99",
        pricePerWeek: 6,
        pricePerWeekFormatted: "",
        pricePeriod: "year"
    )
    
    static let testMonthly = Self(
        id: "testMonthly.fallback.appstore.product.identifier",
        displayPrice: "7.99",
        pricePerWeek: 2,
        pricePerWeekFormatted: "",
        pricePeriod: "month"
    )
}
