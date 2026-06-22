//
//  ApphudProduct.swift
//  aiGeneratorTestTask
//

import ApphudSDK
import Foundation
import StoreKit

extension Collection where Element == ApphudSDK.ApphudProduct {
    
    func toProducts() async -> [Product] {
        await self.asyncMap { try? await $0.product() }.compactMap { $0 }
    }
}
