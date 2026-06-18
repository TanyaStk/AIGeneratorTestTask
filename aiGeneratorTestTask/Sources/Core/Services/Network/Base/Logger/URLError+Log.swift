//
//  URLError+Log.swift
//  aiGeneratorTestTask
//

import Foundation

public extension Error {
    func printLog(from request: URLRequest) {
        let urlString = request.url?.absoluteString ?? ""
        let components = URLComponents(string: urlString)
        
        let path = components?.path ?? ""
        let query = components?.query ?? ""
        
        var responseLog = "\n<----- RESPONSE -----\n"
        responseLog += "\(urlString)\n\n"
        
        responseLog += "HTTP -- \(path)\(query.isEmpty ? "" : "?\(query)")\n"
        if let host = components?.host {
            responseLog += "Host: \(host)\n"
        }
        
        responseLog += "\n"
        responseLog += self.readable
        
        responseLog += "\n<-------------------\n"
        
        #if DEBUG
        print(responseLog)
        #endif
    }
}

extension Error {
    var readable: String {
        "ERROR: \(self.localizedDescription)"
    }
}
