//
//  Product+toDomain.swift
//  aiGeneratorTestTask
//

import Foundation
import StoreKit

extension Product {
    
    func toDomain() -> PaywallProductModel? {
        guard let period = subscription?.subscriptionPeriod else { return nil }
        
        let pricePerWeek = price / Decimal(subscription?.subscriptionPeriod.weekAmount ?? 1)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceFormatStyle.locale
        
        return PaywallProductModel(
            id: id,
            displayPrice: displayPrice,
            pricePerWeek: pricePerWeek,
            pricePerWeekFormatted: formatter.string(from: pricePerWeek as NSDecimalNumber) ?? "",
            pricePeriod: period.localizedPeriod
        )
    }
}

private extension Product.SubscriptionPeriod {
    
    var weekAmount: Double {
        switch self.unit {
        case .day: 1 / 7
        case .week: 1
        case .month: 4
        case .year: 4 * 12
        default: 1
        }
    }
    
    var localizedPeriod: String {
        switch self.unit {
        case .day: value == 7 ? "week" : "day"
        case .week: "week"
        case .month: "month"
        case .year: "year"
        default: ""
        }
    }
}

