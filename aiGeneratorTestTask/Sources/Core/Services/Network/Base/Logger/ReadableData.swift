//
//  PrintableData.swift
//  aiGeneratorTestTask
//
//

import Foundation

extension Dictionary {
    var readable: String {
        self.compactMap({ "\($0.key): \($0.value)" }).joined(separator: "\n")
    }
}

extension Data {
    var readable: String {
        if let jsonObject = try? JSONSerialization.jsonObject(with: self),
           let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
           let jsonString = String(data: prettyData, encoding: .utf8) {
            jsonString
        } else if let text = String(data: self, encoding: .utf8),
                  text.isPrintable {
            text
        } else if self.contains(where: { $0 == 0 }) {
            "Binary File"
        } else {
            "ERROR: Can't render body (not utf8 encoded)"
        }
    }
}

extension String {
    var isPrintable: Bool {
        self.unicodeScalars.allSatisfy({ CharacterSet.printableUnicodeScalars.contains($0) })
    }
}

extension CharacterSet {
    static let printableUnicodeScalars: CharacterSet = {
        var set = CharacterSet()
        set.formUnion(.alphanumerics)
        set.formUnion(.punctuationCharacters)
        set.formUnion(.whitespacesAndNewlines)
        set.formUnion(.symbols)
        return set
    }()
}
