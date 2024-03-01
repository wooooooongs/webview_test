//
//  ContentView.swift
//  SwiftUI_Webview_tutorial
//
//  Created by Jeff Jeong on 2020/07/02.
//  Copyright © 2020 Tuentuenna. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var webViewModel: WebViewModel
    
    @State var textString = ""
    @State var showAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    MyWebView(urlToLoad: "https://www.google.com")
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
                Button(action: {
                    self.webViewModel.newURLSubject.send(.main)
                }, label: {
                    Text("Main WebView")
                    Image("appicon")
                })
                Button(action: {
                    self.webViewModel.newURLSubject.send(.naver)
                }, label: {
                    Text("Naver")
                    Image("naver")
                })
                Button(action: {
                    self.webViewModel.newURLSubject.send(.google)
                }, label: {
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
                    self.webViewModel.webNavigationSubject.send(.back)
                }, label: {
                    Image(systemName: "arrow.backward")
                })
                
                Group {
                    Spacer()
                    Divider()
                    Spacer()
                }
                
                Button(action: {
                    self.webViewModel.webNavigationSubject.send(.refresh)
                }, label: {
                    Image(systemName: "goforward")
                })
                
                Group {
                    Spacer()
                    Divider()
                    Spacer()
                }
                
                Button(action: {
                    self.webViewModel.webNavigationSubject.send(.forward)
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
