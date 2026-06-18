//
//  ApphudService.swift
//  aiGeneratorTestTask
//
//

import Foundation
import ApphudSDK
import Combine
import StoreKit

protocol ApphudServiceType {
    var hasActiveSubscriptionPublisher: AnyPublisher<Bool, Never> { get }
    var productsDomainModelPublisher: AnyPublisher<[PaywallProductModel], Never> { get }
    var hasActiveSubscription: Bool { get }
    
    @MainActor func purchase(productId: String) async throws -> Bool
    @MainActor func restorePurchases() async throws -> Bool
    
    func start(with apiKey: String)
    func getUserID() -> String
}

final class ApphudService: ApphudServiceType {
    
    private let hasActiveSubscriptionSubject = PassthroughSubject<Bool, Never>()
    private let productsModelSubject = CurrentValueSubject<[PaywallProductModel], Never>([])
    private let apphudPaywallsSubject = CurrentValueSubject<[ApphudPaywall], Never>([])

    var hasActiveSubscriptionPublisher: AnyPublisher<Bool, Never> {
        hasActiveSubscriptionSubject.eraseToAnyPublisher()
    }
    
    var productsDomainModelPublisher: AnyPublisher<[PaywallProductModel], Never> {
        productsModelSubject.eraseToAnyPublisher()
    }
    
    var hasActiveSubscription: Bool {
        updateSubscriptionState()
    }
    
    func start(with apiKey: String) {
        Task(priority: .high) {
            Apphud.start(apiKey: apiKey)
            
            setup()
        }
    }
    
    func getUserID() -> String {
        Apphud.userID()
    }
    
    @MainActor
    @discardableResult
    func purchase(productId: String) async throws -> Bool {
        guard let product = findApphudProduct(matching: productId) else {
            throw PaywallError.purchaseProductNotSelected
        }
        
        let result = await Apphud.purchase(product)
        
        if let error = result.error {
            switch error {
                
            case let error as SKError:
                throw PaywallError.purchaseTransactionError(error)
                
            case let error as NSError:
                throw PaywallError.purchaseNetworkError(error)
                
            case let error as ApphudError:
                throw PaywallError.purchaseReceiptError(error)
                
            default:
                throw PaywallError.purchaseUnknownError(error)
            }
        }
        
        if result.subscription == nil {
            throw PaywallError.purchaseValidationError
        }
        
        return updateSubscriptionState()
    }
    
    @MainActor
    @discardableResult
    func restorePurchases() async throws -> Bool {
        await Apphud.restorePurchases()
        let isSubscribedAfterRestore = updateSubscriptionState()
        if !isSubscribedAfterRestore {
            throw PaywallError.restorePurchasesError
        }
        
        return isSubscribedAfterRestore
    }
}

private extension ApphudService {
    func setup() {
        Apphud.setDelegate(self)
        #if DEBUG
        Apphud.enableDebugLogs()
        ApphudUtils.enableAllLogs()
        #endif
    }
    
    func findApphudProduct(matching id: String) -> ApphudProduct? {
        apphudPaywallsSubject
            .value
            .map { $0.products }
            .reduce([], +)
            .first(where: { $0.productId == id })
    }
    
    @discardableResult
    func updateSubscriptionState(_ state: Bool = Apphud.hasActiveSubscription()) -> Bool {
        hasActiveSubscriptionSubject.send(state)
        return state
    }
}

extension ApphudService: ApphudDelegate {
    func apphudSubscriptionsUpdated(_ subscriptions: [ApphudSubscription]) {
        updateSubscriptionState()
    }
    
    func paywallsDidFullyLoad(paywalls: [ApphudPaywall]) {
        Task(priority: .high) {
            let asyncModels = await paywalls.asyncMap { await $0.products.toDomain() } // TODO: - check paywall id
            let domainModels = asyncModels.flatMap { $0 }
            
            print("😎 paywalls", paywalls)
            
            apphudPaywallsSubject.send(paywalls)
            productsModelSubject.send(domainModels)
            updateSubscriptionState()
        }
    }
}
