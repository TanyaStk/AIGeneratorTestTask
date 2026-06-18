//
//  WebView.swift
//  aiGeneratorTestTask
//
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let urlString: String
    
    @Binding var webView: WKWebView?
    
    func makeUIView(context: Context) -> some WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.mediaTypesRequiringUserActionForPlayback = .all
        configuration.allowsInlineMediaPlayback = true
        let wkWebView = WKWebView(frame: .zero, configuration: configuration)
        
        if let url = URL(string: urlString) {
            wkWebView.load(URLRequest(url: url))
        }
        
        Task { @MainActor in
            webView = wkWebView
        }
        
        return wkWebView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) { }
}
