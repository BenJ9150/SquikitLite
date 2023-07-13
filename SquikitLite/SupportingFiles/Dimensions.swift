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
    
    static let headerHeight: CGFloat = 48
    
    // MARK: Provisions CollectionView
    
    static let provisionsCellWidth: CGFloat = 156
    static let provisionsCellHeight: CGFloat = 152
    static let provisionsCellSpace: CGFloat = 16
    static let provisionCollectionViewTopInset: CGFloat = provisionsCellSpace
    static let provisionCollectionViewBottomInset: CGFloat = 100
    
    // MARK: Add provisions CollectionView
    
    static let addProvsCellWidth: CGFloat = 108
    static let addProvsCellHeight: CGFloat = 46
    static let addProvsCellSpace: CGFloat = 8
    static let addProvsCellTopInset: CGFloat = 8
    static let addProvsCellBottomInset: CGFloat = 16
    
    // MARK: Shopping TableView
    
    static let shoppingRowSpace: CGFloat = 6
    static let shoppingRowHeight: CGFloat = 64 + shoppingRowSpace // espace dans le Xib (on ne peut pas mettre d'espace entre les lignes)
    static let shoppingTableViewTopInset: CGFloat = provisionCollectionViewTopInset
    static let shoppingTableViewBottomInset: CGFloat = provisionCollectionViewBottomInset

    
    // MARK: Floating buttons
    
    static let floatingButtonDim: CGFloat = 56
    
    // MARK: main tabBar
    
    static let mainTabBarHeight: CGFloat = 49
    static let mainTabBarHeightCompact: CGFloat = 32
    static let mainTabBarMiddleButtonOffset: CGFloat = 8 // positive: button up
}
