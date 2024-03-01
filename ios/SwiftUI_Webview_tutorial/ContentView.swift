//
//  ContentView.swift
//  SwiftUI_Webview_tutorial
//
//  Created by Jeff Jeong on 2020/07/02.
//  Copyright © 2020 Tuentuenna. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var textString = ""
    @State var showAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    MyWebview(urlToLoad: "https://www.google.com")
                    webViewTabBar
                }
                .navigationBarTitle(Text("웹뷰"), displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        siteMenu
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            self.showAlert.toggle()
                        }, label: {
                            Text("iOS -> JS")
                        })
                    }
                }
                
                if self.showAlert {
                    createTextAlert()
                }
            }
        }
    }
    
    // 사이트 메뉴
    private var siteMenu: some View {
        Text("이동")
            .foregroundStyle(.black)
            .contextMenu(ContextMenu(menuItems: {
                Button(action: {}, label: {
                    Text("Main WebView")
                    Image("appicon")
                })
                Button(action: {}, label: {
                    Text("Naver")
                    Image("naver")
                })
                Button(action: {}, label: {
                    Text("Google")
                    Image("google")
                })
            }))
    }
    
    // 웹뷰 탭바
    private var webViewTabBar: some View {
        VStack {
            Divider()
            HStack{
                Spacer()
                
                Button(action: {
                    print("뒤로가기")
                }, label: {
                    Image(systemName: "arrow.backward")
                })
                
                Group {
                    Spacer()
                    Divider()
                    Spacer()
                }
                
                Button(action: {
                    print("새로고침")
                }, label: {
                    Image(systemName: "goforward")
                })
                
                Group {
                    Spacer()
                    Divider()
                    Spacer()
                }
                
                Button(action: {
                    print("앞으로 가기")
                }, label: {
                    Image(systemName: "arrow.forward")
                })
                
                Spacer()
            }.frame(height: 45)
        }
    }
}

extension ContentView {
    func createTextAlert() -> MyTextAlertView {
        MyTextAlertView(textString: $textString, showAlert: $showAlert, title: "Send iOS -> JS", message: "")
    }
}

#Preview {
    ContentView()
}
