//
//  UserSession.swift
//  aiGeneratorTestTask
//

import Foundation

protocol UserSessionProvider {
    var userID: String { get }
    
    func setID(_ id: String)
}

final class UserSession: UserSessionProvider {
    
    var userID: String {
        UserDefaults.standard.string(forKey: Constants.userSessionIdKey) ?? ""
    }
    
    func setID(_ id: String) {
        UserDefaults.standard.set(id, forKey: Constants.userSessionIdKey)
    }
}

private extension UserSession {
    enum Constants {
        static let userSessionIdKey = "userID"
    }
}
