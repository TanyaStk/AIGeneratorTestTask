//
//  PurchaseAlertType.swift
//  aiGeneratorTestTask
//
//


enum PurchaseAlertType: String, Identifiable {
    case restore
    case purchase
    
    var id: String { rawValue }
    
    var message: String {
        switch self {
        case .restore:
            "Error occured while restoring."
        case .purchase:
            "Error occured while purchasing."
        }
    }
}
