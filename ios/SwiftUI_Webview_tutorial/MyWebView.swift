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
    @EnvironmentObject var viewModel: WebViewModel
    
    var urlToLoad: String
    static let HANDLER_NAME = "nativeHandler"
    
    func makeUIView(context: Context) -> WKWebView {
        
        // unwrapping
        guard let url = URL(string: self.urlToLoad) else {
            return WKWebView()
        }
        
        let webView = WKWebView(frame: .zero, configuration: createWebViewConfig())
        
        // WKWebView의 Delegate 연결을 위해 Coordinator 설정
        webView.uiDelegate = context.coordinator as any WKUIDelegate
        webView.navigationDelegate = context.coordinator as any WKNavigationDelegate
        webView.allowsBackForwardNavigationGestures = true
        webView.isInspectable = true
        
        webView.load(URLRequest(url: url))
        
        return webView
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
        userContentController.add(self.makeCoordinator(), name: MyWebView.HANDLER_NAME)
        
        let webViewConfig = WKWebViewConfiguration()
        webViewConfig.userContentController = userContentController
        webViewConfig.preferences = preferences
        webViewConfig.defaultWebpagePreferences = webPagePreferences
        
        return webViewConfig
    }
}

// MARK: - WKWebView Delegate Coordinator

// JavaScript에서 WebView를 감지
extension MyWebView.Coordinator: WKUIDelegate {
    
}

// 링크이동 관련
extension MyWebView.Coordinator: WKNavigationDelegate {
    // Main Frame에 웹사이트를 검색을 시작한 시점
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        handleWebNavigationAction(webView)
    }
    
    private func handleWebNavigationAction(_ webView: WKWebView) {
        myWebView
            .viewModel
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
        changeTitle(webView)
        loadNewURL(webView)
        sendToJsBridge(webView)
    }
    
    private func changeTitle(_ webView: WKWebView) {
        webView.evaluateJavaScript("document.title") { (res, err) in
            if let err = err { print("타이틀 에러 \(err)")}
            
            if let title = res as? String {
                self.myWebView.viewModel.titleSubject.send(title)
            }
        }
    }
    
    private func loadNewURL(_ webView: WKWebView) {
        myWebView
            .viewModel
            .newURLSubject
            .compactMap(\.url)
            .sink { newURL in
                webView.load(URLRequest(url: newURL))
            }.store(in: &subscriptions) // Combine에서 제거가 되었을 때, 메모리에서도 지우기
    }
    
    private func sendToJsBridge(_ webView: WKWebView) {
        myWebView
            .viewModel
            .nativeToJsBridgeSubject
            .sink { message in
                webView.evaluateJavaScript("nativeToJsBridge('\(message)');") { result, err in
                    if let result = result {
                        print("nativeToJsBridge 성공! \(result)")
                    }
                    
                    if let err = err {
                        print("nativeToJsBridge 실패... \(err.localizedDescription)")
                    }
                }
            }.store(in: &subscriptions)
    }
}

extension MyWebView.Coordinator: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if message.name == MyWebView.HANDLER_NAME {
            if let receivedData : [String: String] = message.body as? Dictionary {
                
                myWebView.viewModel.jsToNativeBridgeSubject.send(JsAlert(message: receivedData["message"], .jsBridge))
            }
        }
    }
}
