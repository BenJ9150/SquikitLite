//
//  Dimensions.swift
//  SquikitLite
//
//  Created by Benjamin on 26/06/2023.
//

import Foundation



//===========================================================
// MARK: Dimensions class
//===========================================================


// iPhone SE 1st generation width = 320
// iPhone 12 mini width = 360

class Dimensions {
    
    // MARK: Headers
    
    static let provisionsHeaderHeight: CGFloat = 48
    
    // MARK: Cells
    
    static let provisionsCellWidth: CGFloat = 156
    static let provisionsCellHeight: CGFloat = 152
    static let provisionsCellSpace: CGFloat = 16
    static let provisionCollectionViewTopInset: CGFloat = provisionsCellSpace
    static let provisionCollectionViewBottomInset: CGFloat = 100
    static let shoppingTableViewTopInset: CGFloat = 24
    static let shoppingTableViewBottomInset: CGFloat = 100

    
    // MARK: Floating buttons
    
    static let floatingButtonDim: CGFloat = 56
    
    // MARK: main tabBar
    
    static let mainTabBarHeight: CGFloat = 49
    static let mainTabBarHeightCompact: CGFloat = 32
    static let mainTabBarMiddleButtonOffset: CGFloat = 8 // positive: button up
}
