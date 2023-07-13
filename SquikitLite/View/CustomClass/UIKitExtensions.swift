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
    
    func removeShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.0
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        //self.layer.shadowRadius = 2
    }
}



//===========================================================
// MARK: CAShapeLayer
//===========================================================



extension CAShapeLayer {
    
    func addLargeShadow() {
        self.shadowColor = UIColor.black.cgColor
        self.shadowOpacity = 0.2
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



//===========================================================
// MARK: UIControl
//===========================================================



extension UIControl {
    
    // pour réaliser une action en closure sur clic d'un bouton dans une cellule (collection ou tableView)
    func addTouchUpInsideAction(_ closure: @escaping()->()) {
        // on retire l'action pour éviter de s'abonner plusieurs fois
        removeAction(identifiedBy: UIAction.Identifier("ActionInCell"), for: .touchUpInside)
        // on ajoute l'action
        addAction(UIAction(identifier: UIAction.Identifier("ActionInCell"),handler: { _ in
            closure()
        }), for: .touchUpInside)
    }
}



//===========================================================
// MARK: Animation
//===========================================================



class MyAnimations {
    
    static func disappearAndReappear(forViews views: [UIView]) {
        disappearAndReappear(forViews: views) {
            return
        }
    }
    
    static func disappearAndReappear(forViews views: [UIView], completion funcAtEnd: @escaping()->()) {
        if views.count <= 0 {return}
        
        for view in views {
            view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }
        UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5) {
            for view in views {
                view.transform = .identity
            }
        } completion: { _ in
            funcAtEnd()
        }
    }
    
    static func upAndDownWithBounce(forViews views: [UIView], yTranslation: CGFloat) {
        upAndDownWithBounce(forViews: views, yTranslation: yTranslation) {
            return
        }
    }
    
    static func upAndDownWithBounce(forViews views: [UIView], yTranslation: CGFloat, completion funcAtEnd: @escaping()->()) {
        if views.count <= 0 {return}
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut) {
            for view in views {
                view.transform = CGAffineTransform(translationX: 0, y: -yTranslation)
            }
        } completion: { success in
            if success {
                UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5) {
                    for view in views {
                        view.transform = .identity
                    }
                } completion: { _ in
                    funcAtEnd()
                }
            }
        }
    }
}
