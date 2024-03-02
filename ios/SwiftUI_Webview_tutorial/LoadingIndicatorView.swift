//
//  LoadingIndicatorView.swift
//  SwiftUI_Webview_tutorial
//
//  Created by Oscar on 3/3/24.
//  Copyright © 2024 Tuentuenna. All rights reserved.
//

import SwiftUI
import UIKit

struct LoadingIndicatorView: UIViewRepresentable {
    var isAnimating: Bool = true
    var color: UIColor = .black
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIActivityIndicatorView {
        UIActivityIndicatorView()
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Self>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
        uiView.style = .large
        uiView.color = color
    }
}
