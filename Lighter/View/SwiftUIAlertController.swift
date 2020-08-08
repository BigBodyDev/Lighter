//
//  SwiftUIAlertController.swift
//  Lighter
//
//  Created by Devin Green on 7/30/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

struct AlertControlView: UIViewControllerRepresentable {
    
    @Binding var textString: String
    @Binding var showAlert: Bool
    
    var title: String
    var message: String
    var placeholder: String
    var onCommit: () -> ()
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<AlertControlView>) -> UIViewController {
        return UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<AlertControlView>) {
        guard context.coordinator.alert == nil else { return }
        
        if self.showAlert {
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            context.coordinator.alert = alert
            
            alert.addTextField { (textField) in
                textField.placeholder = self.placeholder
                textField.text = self.textString
                textField.delegate = context.coordinator
            }
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .destructive){ _ in
                alert.dismiss(animated: true) {
                    self.showAlert = false
                }
            })
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("Save", comment: ""), style: .default) { _ in
                if let textField = alert.textFields?.first, let text = textField.text{
                    self.textString = text
                }
                
                if self.textString == String() {
                    self.textString = self.placeholder
                }
                
                self.onCommit()
                
                alert.dismiss(animated: true) {
                    self.showAlert = false
                }
            })
            
            DispatchQueue.main.async {
                uiViewController.present(alert, animated: true, completion: {
                    self.showAlert = false
                    context.coordinator.alert = nil
                })
            }
        }
    }
    
    func makeCoordinator() -> AlertControlView.Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var alert: UIAlertController?
        
        var control: AlertControlView
        
        init(_ control: AlertControlView) {
            self.control = control
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if let text = textField.text as NSString? {
                self.control.textString = text.replacingCharacters(in: range, with: string)
            }else{
                self.control.textString = ""
            }
            return true
        }
    }
}
