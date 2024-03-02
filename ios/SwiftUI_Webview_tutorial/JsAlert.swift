//
//  JsAlert.swift
//  SwiftUI_Webview_tutorial
//
//  Created by Oscar on 3/2/24.
//  Copyright © 2024 Tuentuenna. All rights reserved.
//

import Foundation

struct JsAlert: Identifiable {
    enum AlertType: CustomStringConvertible {
        case jsAlert, jsBridge
        
        var description: String {
            switch self {
            case .jsAlert: return "jsAlert"
            case .jsBridge: return "jsBridge"
            }
        }
    }
    
    // Identifiable은 고유값이 필요함
    let id: UUID = UUID()
    var message: String = ""
    
    var type: AlertType
    
    init(message: String? = nil, _ type: AlertType) {
        self.message = message ?? "메시지가 비어있습니다."
        self.type = type
    }
}
