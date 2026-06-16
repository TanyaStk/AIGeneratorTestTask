//
//  TemplateSettingsRaw.swift
//  aiGeneratorTestTask
//

import SwiftUI

extension VideoTemplateDetailView {
    func settingsRow(
        label: String,
        value: String,
        options: [String],
        selection: Binding<String>
    ) -> some View {
        HStack {
            Text(label)
                .opacity(0.6)
            
            Spacer()
            
            Menu {
                ForEach(options, id: \.self) { option in
                    Button(option) { selection.wrappedValue = option }
                }
            } label: {
                Text(value)
            }
        }
        .font(.system(size: 16, weight: .medium))
        .foregroundStyle(.accent)
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
        .background(.card.opacity(0.5))
        .clipShape(.rect(cornerRadius: 24, style: .continuous))
    }
}
