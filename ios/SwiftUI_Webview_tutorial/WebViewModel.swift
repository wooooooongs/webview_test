//
//  WebViewModel.swift
//  SwiftUI_Webview_tutorial
//
//  Created by Oscar on 3/1/24.
//  Copyright © 2024 Tuentuenna. All rights reserved.
//

import Foundation
import Combine

// 별칭
typealias WEB_NAVIGATION = WebViewModel.Navigation

class WebViewModel: ObservableObject {
    enum Navigation {
        case back, refresh, forward
    }
    
    enum URL_TYPE {
        case naver
        case google
        case main
        
        var url: URL? {
            switch self {
            case .naver:        return URL(string: "https://www.naver.com")
            case .google:       return URL(string: "https://www.google.com")
            case .main:         return URL(string: "https://wooooooongs.github.io/webview_test/")
            }
        }
    }
    
    // 웹뷰의 URL이 변경되었을 때 이벤트 전달해줌.
    var newURLSubject = PassthroughSubject<WebViewModel.URL_TYPE, Never>()
    // 웹뷰의 Navigation Action Event
    var webNavigationSubject = PassthroughSubject<WEB_NAVIGATION, Never>()
}
