//
//  PaywallBottomView.swift
//  aiGeneratorTestTask
//

import SwiftUI

struct PaywallBottomView: View {
    
    var linkSelection: (PaywallLink) -> ()
    var restore: () -> ()
    
    var body: some View {
        HStack {
            makeButton(with: "Privacy Policy", action: {
                linkSelection(.privacy)
            })
            
            makeButton(with: "Restore Purchases", action: {
                restore()
            })
            .frame(maxWidth: .infinity)
            
            makeButton(with: "Terms of Use", action: {
                linkSelection(.terms)
            })
        }
    }
    
    private func makeButton(with title: String, action: @escaping () -> ()) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 11))
                .foregroundStyle(.paywallGrey)
        }
    }
}

#Preview {
    PaywallBottomView(linkSelection: {_ in }, restore: {})
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
}
