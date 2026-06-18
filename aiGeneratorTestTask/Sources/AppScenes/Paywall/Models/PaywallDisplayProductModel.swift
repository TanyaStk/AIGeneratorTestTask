//
//  PaywallDisplayProductModel.swift
//  aiGeneratorTestTask
//

import Foundation

struct PaywallDisplayProductModel: Identifiable, Equatable {
    let id: String
    let perWeekPrice: String
    let perWeekString: String
    let totalPrice: String
    let saleAmount: Int?
}
