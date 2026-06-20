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
    
    static let testYearly = Self(
        id: "testYearly.fallback.appstore.product.identifier",
        price: "69.99",
        priceFormat: "$",
        weeksInPeriodAmount: 48,
        pricePeriod: "year"
    )
    
    static let testMonthly = Self(
        id: "testMonthly.fallback.appstore.product.identifier",
        price: "7.99",
        priceFormat: "$",
        weeksInPeriodAmount: 4,
        pricePeriod: "month"
    )
}
