//
//  MyWebView.swift
//  SwiftUI_Webview_tutorial
//
//  Created by Jeff Jeong on 2020/07/02.
//  Copyright © 2020 Tuentuenna. All rights reserved.
//

import SwiftUI
import WebKit
import Combine

// UIKit 의 UIView 를 사용할수 있도록 한다.
// UIViewControllerRepresentable
struct MyWebView: UIViewRepresentable {
    @EnvironmentObject var webViewModel: WebViewModel
    
    var urlToLoad: String
    
    func makeUIView(context: Context) -> WKWebView {
        
        // unwrapping
        guard let url = URL(string: self.urlToLoad) else {
            return WKWebView()
        }
        
        let webview = WKWebView(frame: .zero, configuration: createWebViewConfig())
        
        // WKWebView의 Delegate 연결을 위해 Coordinator 설정
        webview.uiDelegate = context.coordinator as any WKUIDelegate
        webview.navigationDelegate = context.coordinator as any WKNavigationDelegate
        webview.allowsBackForwardNavigationGestures = true
        
        webview.load(URLRequest(url: url))
        
        return webview
    }
    
    // UI 업데이트 시 호출
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<MyWebView>) {
        
    }
    
    // MARK: - Coordinator
    func makeCoordinator() -> MyWebView.Coordinator {
        return MyWebView.Coordinator(webView: self)
    }
    
    class Coordinator: NSObject {
        var myWebView: MyWebView // SwiftUI View
        var subscriptions = Set<AnyCancellable>() // RxSwift DisposeBag과 유사한 역할
        
        init(webView: MyWebView) {
            self.myWebView = webView
        }
    }
    
    // MARK: - WKWebView 설정
    func createWebViewConfig() -> WKWebViewConfiguration {
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = true
        
        let webPagePreferences = WKWebpagePreferences()
        webPagePreferences.allowsContentJavaScript = true
        
        let userContentController = WKUserContentController()
        userContentController.add(self.makeCoordinator(), name: "callbackHandler")
        
        let webViewConfig = WKWebViewConfiguration()
        webViewConfig.userContentController = userContentController
        webViewConfig.preferences = preferences
        webViewConfig.defaultWebpagePreferences = webPagePreferences
        
        return webViewConfig
    }
}

// MARK: - WKWebView Delegate Coordinator

extension MyWebView.Coordinator: WKUIDelegate {
    
}

// 링크이동 관련
extension MyWebView.Coordinator: WKNavigationDelegate {
    // Main Frame에 웹사이트를 검색을 시작한 시점
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        myWebView
            .webViewModel
            .webNavigationSubject
            .sink { action in
                switch action {
                case .back:
                    if webView.canGoBack {
                        webView.goBack()
                    }
                case .forward:
                    if webView.canGoForward {
                        webView.goForward()
                    }
                case .refresh:
                    webView.reload()
                }
            }.store(in: &subscriptions)
    }
    
    // URL 변경
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        myWebView
            .webViewModel
            .changedURLSubject
            .compactMap { webViewModel in
                return webViewModel.url
            }
            .sink { newURL in
                webView.load(URLRequest(url: newURL))
            }.store(in: &subscriptions) // Combine에서 제거가 되었을 때, 메모리에서도 지우기
    }
}

// 서버에서 JS를 호출해서 설정하는 머시기
extension MyWebView.Coordinator: WKScriptMessageHandler {
    
    // WebView JavaScript에서 호출하는 메서드 들을 아래 함수를 거친다.
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("userContentController, \(message)")
    }
}

#Preview {
    MyWebView(urlToLoad: "https://www.naver.com")
}
