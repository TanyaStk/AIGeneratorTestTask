//
//  VideoCategory.swift
//  aiGeneratorTestTask
//


import Foundation

struct VideoCategory: Identifiable, Hashable {
    let id = UUID()
    let name: String
    
    init(_ name: String) {
        self.name = name
    }
}
