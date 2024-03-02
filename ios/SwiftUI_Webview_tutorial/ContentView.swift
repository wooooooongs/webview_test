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
    
    @State var textString: String = ""
    @State var showAlert: Bool = false
    
    @State var jsAlert: JsAlert?
    
    @State var webTitle: String = ""
    @State var isLoading: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    MyWebView(urlToLoad: "https://wooooooongs.github.io/webview_test/")
                    webViewTabBar
                }
                .navigationBarTitle(Text(webTitle), displayMode: .inline)
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
                .alert(item: $jsAlert) { jsAlert in
                    createAlert(jsAlert)
                }
                
                if self.showAlert {
                    createTextAlert()
                }
                
                if self.isLoading {
                    LoadingIndicatorView()
                }
            }
            .onReceive(webViewModel.titleSubject) { newWebTitle in
                self.webTitle = newWebTitle
            }
            .onReceive(webViewModel.jsToNativeBridgeSubject) { jsAlert in
                self.jsAlert = jsAlert
            }
            .onReceive(webViewModel.shouldShowLoadingIndicator) { isLoading in
                self.isLoading = isLoading
            }
        }
    }
    
    // MARK: - SiteMenu
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
    
    // MARK: - TabBar
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
    
    func createAlert(_ alert: JsAlert) -> Alert {
        Alert(
            title: Text(alert.type.description),
            message: Text(alert.message),
            dismissButton: .default(Text("확인"), action: {
            print("Alert 창 닫기")
        }))
    }
}

#Preview {
    ContentView()
}
