//
//  SettingsView.swift
//  aiGeneratorTestTask
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            NavigationBarView {
                Text("Settings")
                    .asNavigationTitle()
            }
            .background(.card.opacity(0.4))
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Color.background)
    }
}

#Preview {
    SettingsView()
}
