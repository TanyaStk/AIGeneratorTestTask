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
            let asyncModels = await paywalls
                .filter({ $0.identifier == AppConstants.Apphud.paywallID })
                .asyncMap { await $0.products.toDomain() }
            let domainModels = asyncModels.flatMap { $0 }
            
            apphudPaywallsSubject.send(paywalls)
            productsModelSubject.send(domainModels)
            updateSubscriptionState()
        }
    }
}

// MARK: - Mock

final class MockApphudService: ApphudServiceType {
    private let hasActiveSubscriptionSubject = PassthroughSubject<Bool, Never>()
    private let paywallsModelSubject = CurrentValueSubject<[PaywallProductModel], Never>([])
    
    var hasActiveSubscription: Bool {
        false
    }
    
    private func initialize() async {
        try? await Task.sleep(nanoseconds: 3_500_000_000)
        
        // simulate premium / paywalls updates
        // with any rules & mock data you want
        hasActiveSubscriptionSubject.send(true)
        paywallsModelSubject.send([.testYearly, .testMonthly])
    }
    
    var hasActiveSubscriptionPublisher: AnyPublisher<Bool, Never> {
        // simulate success or failure
        hasActiveSubscriptionSubject.eraseToAnyPublisher()
    }
    
    var paywallsDomainModelPublisher: AnyPublisher<[PaywallProductModel], Never> {
        // simulate success or failure
        paywallsModelSubject.eraseToAnyPublisher()
    }
    
    var productsDomainModelPublisher: AnyPublisher<[PaywallProductModel], Never> {
        paywallsModelSubject.eraseToAnyPublisher()
    }
    
    func getUserID() -> String { "" }
    
    @MainActor
    func purchase(productId: String) async throws -> Bool {
        // simulate success or failure
        try? await Task.sleep(nanoseconds: 3_500_000_000)
        
        return true
    }
    
    @MainActor
    func restorePurchases() async throws -> Bool {
        // simulate success or failure
        throw PaywallError.initializeError
    }
    
    func start(with apiKey: String) {
        Task {
            await initialize()
        }
    }

}

