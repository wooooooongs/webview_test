//
//  LoadingScreenView.swift
//  SwiftUI_Webview_tutorial
//
//  Created by Oscar on 3/3/24.
//  Copyright © 2024 Tuentuenna. All rights reserved.
//

import SwiftUI

struct LoadingScreenView: View {
    var body: some View {
        ZStack(alignment: .center, content: {
            Color.black
                .opacity(0.9)
                .ignoresSafeArea(edges: .all)
            LoadingIndicatorView()
        })
    }
}
