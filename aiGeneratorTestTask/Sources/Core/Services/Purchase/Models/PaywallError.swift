//
//  PaywallError.swift
//  aiGeneratorTestTask
//

import Foundation

enum PaywallError: Error {
    case initializeError
    case paywallNotFound
    case restorePurchasesError
    case purchaseProductNotSelected
    case purchaseTransactionError(Error)
    case purchaseNetworkError(Error)
    case purchaseReceiptError(Error)
    case purchaseUnknownError(Error)
    case purchaseValidationError
}
