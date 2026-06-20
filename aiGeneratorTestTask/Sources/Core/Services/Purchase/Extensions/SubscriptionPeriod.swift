//
//  SubscriptionPeriod+.swift
//  aiGeneratorTestTask
//

import Foundation
import StoreKit

extension Product.SubscriptionPeriod {
    
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
