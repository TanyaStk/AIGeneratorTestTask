//
//  URLRequest+Log.swift
//  aiGeneratorTestTask
//
//

import Foundation

extension URLRequest {
    func printRequestLog() {
        let urlString = self.url?.absoluteString ?? ""
        let components = URLComponents(string: urlString)
        
        let method = self.httpMethod ?? ""
        let path = components?.path ?? ""
        let query = components?.query ?? ""
        let host = components?.host ?? ""
        
        var requestLog = "\n----- REQUEST ----->\n"
        requestLog += "\(urlString)\n"
        requestLog += "\(method) \(path)\(query.isEmpty ? "" : "?\(query)") HTTP/1.1\n"
        requestLog += "Host: \(host)"
        if let headers = self.allHTTPHeaderFields,
           !(headers.keys.isEmpty || headers.readable.isEmpty) {
            requestLog += "\nHeaders:\n"
            requestLog += headers.readable
        }
        
        if let data = self.httpBody {
            requestLog += "\nBody:\n"
            requestLog += data.readable
        }
        
        requestLog += "\n\ncURL: \n\(self.curl)"
        requestLog += "\n------------------->\n"
        #if DEBUG
        print(requestLog)
        #endif
    }
}

extension URLRequest {
    var curl: String {
        let newLine = "\\\n"
        let method = "--request " + "\(self.httpMethod ?? "GET") \(newLine)"
        let url = "--url " + "\'\(self.url?.absoluteString ?? "")\' \(newLine)"
        
        var curl = "curl "
        var header = ""
        var data = ""
        
        if let headers = self.allHTTPHeaderFields,
           !headers.keys.isEmpty {
            headers.forEach({ header += "--header " + "\'\($0.key): \($0.value)\' \(newLine)" })
        }
        
        if let body = self.httpBody,
           let bodyString = String(data: body, encoding: .utf8),
           !bodyString.isEmpty {
            data = "--data '\(bodyString)'"
        }
        
        curl += method + url + header + data
        return curl
    }
}
