//
//  PaywallViewModel.swift
//  aiGeneratorTestTask
//

import Foundation
import Combine

final class PaywallViewModel: ObservableObject {
    
    @Published var state = State()
    
    @Injected(\.apphudService)
    private var apphudService
    
    private var cancellables = Set<AnyCancellable>()
    private var completion: (() -> Void)?
    
    init(completion: (() -> Void)? = nil) {
        self.completion = completion
        
        delayCloseAppearance()
        observeApphudService()
    }
    
    func selectProduct(_ product: PaywallDisplayProductModel) {
        state.selectedProduct = product
    }
    
    func openLink(_ link: PaywallLink) {
        state.showWebViewWithLink = link
    }
    
    func closePaywall() {
        completion?()
    }
    
    func makePurchase() {
        guard let product = state.selectedProduct else { return }
        
        state.isLoadingPurchase.toggle()
        
        Task {
            do {
                let _ = try await apphudService.purchase(productId: product.id)
                await MainActor.run {
                    state.isLoadingPurchase.toggle()
                    closePaywall()
                }
            } catch {
                await MainActor.run {
                    state.alertType = .purchase
                    state.shouldShowAlert.toggle()
                    state.isLoadingPurchase.toggle()
                }
            }
        }
    }
    
    func restore() {
        state.isLoadingPurchase.toggle()
        
        Task {
            do {
                let _ = try await apphudService.restorePurchases()
                await MainActor.run {
                    state.isLoadingPurchase.toggle()
                    closePaywall()
                }
            } catch {
                await MainActor.run {
                    state.alertType = .restore
                    state.shouldShowAlert.toggle()
                    state.isLoadingPurchase.toggle()
                }
            }
        }
    }
    
    func tryAgain() {
        switch state.alertType {
        case .restore:
            restore()
        case .purchase:
            makePurchase()
        case .none:
            break
        }
    }
}

private extension PaywallViewModel {
    
    func observeApphudService() {
        apphudService.productsDomainModelPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.applyProducts($0) }
            .store(in: &cancellables)
    }
    
    func applyProducts(_ products: [PaywallProductModel]) {
        guard !products.isEmpty else { return }
        
        let perWeekPrices = products.map { product in
            (Double(product.price) ?? 0) / product.weeksInPeriodAmount
        }
        
        let baselinePerWeekPrice = perWeekPrices.max() ?? 0
        
        state.products = zip(products, perWeekPrices).map { product, perWeekPrice in
            let saleAmount = calculateSaleAmount(
                perWeekPrice: perWeekPrice,
                baselinePerWeekPrice: baselinePerWeekPrice
            )
            
            return .init(
                id: product.id,
                perWeekPrice: "\(product.pricePeriod) \(product.priceFormat)\(perWeekPrice.roundedString)",
                perWeekString: "/ week",
                totalPrice: "\(product.priceFormat) \(product.price)",
                saleAmount: saleAmount
            )
        }
        .sorted(by: { $0.saleAmount > $1.saleAmount })
        
        state.selectedProduct = state.products?.first
    }
    
    func calculateSaleAmount(perWeekPrice: Double, baselinePerWeekPrice: Double) -> Int {
        guard baselinePerWeekPrice > 0 else { return 0 }
        
        let discount = 1 - (perWeekPrice / baselinePerWeekPrice)
        
        return Int((discount * 100).rounded())
    }
    
    func delayCloseAppearance() {
        Task {
            try? await Task.sleep(for: .seconds(2))
            
            await MainActor.run {
                state.shouldShowCloseButton.toggle()
            }
        }
    }
}

extension PaywallViewModel {
    
    struct State {
        var products: [PaywallDisplayProductModel]?
        var selectedProduct: PaywallDisplayProductModel?
        var isLoadingPurchase: Bool = false
        var shouldShowAlert: Bool = false
        var alertType: PurchaseAlertType?
        var showWebViewWithLink: PaywallLink?
        var shouldShowCloseButton: Bool = false
    }
}

private extension Double {
    
    var roundedString: String {
        String(format: "%.2f", self)
    }
}
