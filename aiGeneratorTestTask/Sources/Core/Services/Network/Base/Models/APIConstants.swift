//
//  APIConstants.swift
//  aiGeneratorTestTask
//
//

import Foundation

enum APIConstants {
    static let baseURL = "https://nebulaapps.site"
    static let appId = "com.test.test"
    static let bearerToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwiZW1haWwiOiJzaGFyb3ZfMTk5OUBsaXN0LnJ1Iiwicm9sZSI6IkFETUlOIiwiZXhwIjo0OTM1MjA4NjcxLCJpYXQiOjE3ODE2MDg2NzEsInR5cGUiOiJhY2Nlc3MifQ.0GRnZq1LZA__0G0tYEsPER8lQiCiX_myE6_T_nMwUmc"
    
    enum Paths {
        static let templates = "/pixverse/api/v1/get_templates/\(APIConstants.appId)"
        static let generateVideo = "/pixverse/api/v1/template2video"
        static let videoStatus = "/pixverse/api/v1/status"
        
        static func chatMessages(chatId: String) -> String {
            "/dola/chats/\(chatId)/messages"
        }
    }
}
