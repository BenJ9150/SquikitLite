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
