//
//  ApphudProduct.swift
//  aiGeneratorTestTask
//

import ApphudSDK
import Foundation
import StoreKit

extension ApphudSDK.ApphudProduct {
    
    func toDomain() async -> PaywallProductModel {
        let fallback = PaywallProductModel.fallback
        
        async let product = try? await product()
        
        return await .init(
            id: self.productId,
            price: product?.price.roundedString ?? fallback.price,
            priceFormat: product?.priceFormatStyle.currencyCode ?? fallback.priceFormat,
            weeksInPeriodAmount: product?.subscription?.subscriptionPeriod.weekAmount ?? fallback.weeksInPeriodAmount,
            pricePeriod: product?.subscription?.subscriptionPeriod.localizedPeriod ?? fallback.pricePeriod
        )
    }
}

private extension Decimal {
    
    var roundedString: String {
        let double = NSDecimalNumber(decimal: self).doubleValue
        let string = String(format: "%.2f", double)
        
        return string
    }
}

extension Collection where Element == ApphudSDK.ApphudProduct {
    
    func toDomain() async -> [PaywallProductModel] {
        await self.asyncMap { await $0.toDomain() }
    }
}
