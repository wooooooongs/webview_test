//
//  MyTextAlertView.swift
//  SwiftUI_Webview_tutorial
//
//  Created by Oscar on 2/27/24.
//  Copyright © 2024 Tuentuenna. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

// SwiftUI의 프로토콜로, UIKit VC를 SwiftUI에서 사용할 수 있게 함
struct MyTextAlertView: UIViewControllerRepresentable {
    // ContentView의 State에 연결되어 있다.
    @EnvironmentObject var webViewModel: WebViewModel
    
    @Binding var textString: String
    @Binding var showAlert: Bool
    
    var title: String
    var message: String

    // VC가 생성되었을 때 호출된다.
    func makeUIViewController(context: UIViewControllerRepresentableContext<MyTextAlertView>) -> UIViewController {
        
        return UIViewController()
    }

    
    // VC의 업데이트가 필요할 때 호출된다.
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: UIViewControllerRepresentableContext<MyTextAlertView>) {
        
        // UIAlertController가 존재하지 않다면, 종료
        let isUiAlertControllerExist = context.coordinator.uiAlertController == nil
        guard isUiAlertControllerExist else { return }
        
        if self.showAlert {
            let uiAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            uiAlertController.addTextField { textField in
                textField.placeholder = "전달 값을 입력하세요"
                textField.text = textString
            }
            
            uiAlertController.addAction(UIAlertAction(title: "취소", style: .destructive, handler: { _ in
                print("취소")
                clearText()
            }))
            
            uiAlertController.addAction(UIAlertAction(title: "보내기", style: .default, handler: { _ in
                print("보내기")
                
                if let textField = uiAlertController.textFields?.first,
                   let inputValue = textField.text {
                    self.textString = inputValue
                }
                
                uiAlertController.dismiss(animated: true) {
                    print("보냈다!:", self.textString)
                    
                    self.webViewModel.nativeToJsBridgeSubject.send(self.textString)
                    clearText()
                    closeAlert()
                }
            }))
            
            presentWithMainThread(uiViewController, uiAlertController, context)
        }
    }
    
    // MARK: - Methods
    private func clearText() {
        self.textString = ""
    }
    
    private func closeAlert() {
        self.showAlert = false
    }
    
    private func presentWithMainThread(_ uiViewController: UIViewControllerType, _ uiAlertController: UIAlertController,_ context: UIViewControllerRepresentableContext<MyTextAlertView>) {
        DispatchQueue.main.async {
            uiViewController.present(uiAlertController, animated: true) {
                closeAlert()
                
                context.coordinator.uiAlertController = nil
            }
        }
    }
    
    // MARK: - Coordinator
    func makeCoordinator() -> MyTextAlertView.Coordinator {
        MyTextAlertView.Coordinator(self)
    }
    
    // 중간 매개체, UIKit의 Delegate 등 이벤트를 받아주는 역할을 한다.
    class Coordinator: NSObject {
        var uiAlertController: UIAlertController? // 연결하려는 UIKit View
        var myTextAlertView: MyTextAlertView // SwiftUI View, @Binding textString을 가지고 있다.
        // 위 두 개를 연결해준다.
        
        init(_ myTextAlertView: MyTextAlertView) {
            self.myTextAlertView = myTextAlertView
        }
    }
}

// Delegate를 SwiftUI View에서 받기 위해선 Coordinator를 사용해야 한다
extension MyTextAlertView.Coordinator: UITextFieldDelegate {
    // TextField 변경 인식
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            // 입력된 값을 넣어준다
            self.myTextAlertView.textString = text.replacingCharacters(in: range, with: string)
        } else {
            self.myTextAlertView.textString = ""
        }
        
        return true
    }
}
