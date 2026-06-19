//
//  MultipartFile.swift
//  aiGeneratorTestTask
//

import Foundation

struct MultipartFile {
    let name: String
    let filename: String
    let mimeType: String
    let data: Data
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
