//
//  Link.swift
//  aiGeneratorTestTask
//


enum PaywallLink: Int, Identifiable {
    case terms = 1
    case privacy
    
    var id: Int {
        rawValue
    }
    
    var linkString: String {
        switch self {
        case .terms:
            AppConstants.PaywallLink.termsUrl
        case .privacy:
            AppConstants.PaywallLink.privacyUrl
        }
    }
}
