//
//  UIKitExtensions.swift
//  SquikitLite
//
//  Created by Benjamin on 29/06/2023.
//

import UIKit



//===========================================================
// MARK: UIView
//===========================================================



extension UIView {
    
    func addSmallShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        //self.layer.shadowRadius = 2
    }
    
    func addLargeShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        //self.layer.shadowRadius = 2
    }
}



//===========================================================
// MARK: CAShapeLayer
//===========================================================



extension CAShapeLayer {
    
    func addLargeShadow() {
        self.shadowColor = UIColor.black.cgColor
        self.shadowOpacity = 0.1
        self.shadowOffset = CGSize(width: 0, height: 4)
        //self.layer.shadowRadius = 2
    }
}



//===========================================================
// MARK: UITextField
//===========================================================



extension UITextField {
    
    func addDoneOnNumericPad() {
        // create toolbar
        let keypadToolbar: UIToolbar = UIToolbar()
        // add done item
        keypadToolbar.items = [
        UIBarButtonItem(title: "OK", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.resignFirstResponder)),
        UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        ]
        keypadToolbar.sizeToFit()
        // add toolbar to textfield
        self.inputAccessoryView = keypadToolbar
    }
}



//===========================================================
// MARK: Alert
//===========================================================



class AlertButton {
    
    let cancel = UIAlertAction(title: NSLocalizedString("alert_cancel", comment: ""), style: .cancel)
}
