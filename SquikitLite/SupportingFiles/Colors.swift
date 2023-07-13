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
    static let mainButton = UIColor(named: "color_mainButton")!
    static let mainTabBar = UIColor(named: "color_mainTabBar")!
    static let mainNavigation = UIColor(named: "color_mainNavigation")!
    static let inactiveButton = UIColor(named: "color_inactiveButton")!
    static let provisionName = UIColor(named: "color_provisionName")!
    static let whiteBackground = UIColor(named: "color_whiteBackground")!
    static let whiteLabel = UIColor(named: "color_whiteLabel")!
    static let whiteButton = UIColor(named: "color_whiteButton")!
    static let creole = UIColor(named: "color_creole")!
    static let quantityAndUnit = UIColor(named: "color_quantityAndUnit")!
    static let rowSelection = UIColor(named: "color_rowSelection")!
    
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


