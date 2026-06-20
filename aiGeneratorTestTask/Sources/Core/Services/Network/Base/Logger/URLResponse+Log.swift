//
//  URLResponse+Log.swift
//  aiGeneratorTestTask
//
//

import Foundation

public extension URLResponse {
    func printLog(data: Data) {
        let httpUrlResponse = self as? HTTPURLResponse
        let urlString = self.url?.absoluteString ?? ""
        let components = URLComponents(string: urlString)
        
        let path = components?.path ?? ""
        let query = components?.query ?? ""
        
        var responseLog = "\n<----- RESPONSE -----\n"
        responseLog += "\(urlString)\n\n"
        var statusCodeString = ""
        if let statusCode = httpUrlResponse?.statusCode {
            statusCodeString = "\(statusCode)"
        }
        
        responseLog += "HTTP \(statusCodeString) \(path)\(query.isEmpty ? "" : "?\(query)")\n"
        if let host = components?.host {
            responseLog += "Host: \(host)\n"
        }
        
        responseLog += "Headers:\n"
        responseLog += httpUrlResponse?.allHeaderFields.readable ?? ""
        
        responseLog += "\nResponse:\n"
        responseLog += data.readable
        
        responseLog += "\n<-------------------\n"
        
        #if DEBUG
        print(responseLog)
        #endif
    }
}
