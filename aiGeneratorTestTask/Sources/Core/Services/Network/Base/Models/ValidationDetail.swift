//
//  ValidationDetail.swift
//  aiGeneratorTestTask
//

import Foundation

struct ValidationDetail: Decodable {
    let loc: [AnyCodable]
    let msg: String
    let type: String
}

struct AnyCodable: Decodable {
    
    let value: Any
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let int = try? container.decode(Int.self) {
            value = int
            return
        }
        
        if let string = try? container.decode(String.self) {
            value = string
            return
        }
        value = ""
    }
}
