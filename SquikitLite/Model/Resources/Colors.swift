//
//  Colors.swift
//  SquikitLite
//
//  Created by Benjamin on 22/06/2023.
//

import Foundation
import UIKit



//===========================================================
// MARK: Color extensions
//===========================================================



extension UIColor {
    
    // MARK: main colors
    
    static let mainBackground = UIColor(named: "color_mainBackground")!
    static let mainTabBar = UIColor(named: "color_mainTabBar")!
    static let mainNavigation = UIColor(named: "color_mainNavigation")!
    
    // MARK: DLC
    
    static let dlcMoyen = UIColor(named: "color_dlcMoyen")!
    static let dlcNormal = UIColor(named: "color_dlcNormal")!
    static let dlcUrgent = UIColor(named: "color_dlcUrgent")!
    static let dlcDesactivated = mainBackground
}



extension CGColor {
    
    // MARK: main colors
    
    static let mainTabBar = UIColor.mainTabBar.cgColor
}


