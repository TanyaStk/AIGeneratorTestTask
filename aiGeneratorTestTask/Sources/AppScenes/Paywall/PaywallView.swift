//
//  PaywallView.swift
//  aiGeneratorTestTask
//

import SwiftUI

struct PaywallView: View {
    
    @StateObject var viewModel: PaywallViewModel
    
    var body: some View {
        VStack(spacing: 18) {
            Button {
                viewModel.closePaywall()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 17, weight: .regular))
                    .opacity(viewModel.state.shouldShowCloseButton ? 1 : 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .disabled(!viewModel.state.shouldShowCloseButton)
            .padding(.top, 16)
            .layoutPriority(-1)
            
            OfferView()
                .layoutPriority(1)
                .padding(.bottom, 10)
            
            if let products = viewModel.state.products {
                ForEach(products) { product in
                    PriceView(
                        product: product,
                        isSelected: product == viewModel.state.selectedProduct
                    )
                    .onTapGesture {
                        viewModel.selectProduct(product)
                    }
                }
            } else {
                PinkProgressView()
                    .frame(height: 100)
            }
            
            cancelAnyTimeButton
            
            if viewModel.state.isLoadingPurchase {
                PinkProgressView()
                    .frame(height: 52)
            } else {
                purchaseButton
            }
            
            PaywallBottomView(linkSelection: viewModel.openLink(_:), restore: viewModel.restore)
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image(.Images.Paywall.background)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
        .background(Color.background)
        .animation(.easeOut, value: viewModel.state.products)
        .animation(.linear, value: viewModel.state.shouldShowCloseButton)
        .sheet(item: $viewModel.state.showWebViewWithLink, content: { linkType in
            WebView(urlString: linkType.linkString, webView: .constant(nil))
        })
        .modifier(PaywallAlertsDisplay(
            alertType: viewModel.state.alertType,
            isPresented: $viewModel.state.shouldShowAlert,
            retryAction: viewModel.tryAgain
        ))
    }
    
    private var purchaseButton: some View {
        Button(action: viewModel.makePurchase) {
            Text("Unlock now")
                .asGradientButton()
        }
    }
    
    private var cancelAnyTimeButton: some View {
        Button {
            
        } label: {
            HStack {
                Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                
                Text("Cancel Anytime")
            }
            .font(.system(size: 12))
            .foregroundStyle(.paywallGrey)
        }
        .disabled(true)
        .padding(.top, 14)
    }
}

#Preview {
    PaywallView(viewModel: .init())
}
