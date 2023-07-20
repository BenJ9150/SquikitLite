//
//  CollViewGenericMethods.swift
//  SquikitLite
//
//  Created by Benjamin on 11/07/2023.
//

import Foundation
import UIKit



//===========================================================
// MARK: CollViewGenericMethods class
//===========================================================



class CollViewGenericMethods {
    
    static func getCellWidth(forCV collectionView: UICollectionView, withTarget cellWidthTarget: CGFloat, andSpace cellSpace: CGFloat) -> CGFloat {
        // largeur de l'écran
        let viewWidth = collectionView.bounds.width
        
        // nombre de colonne possible
        let columnNb = (viewWidth - cellSpace) / (cellWidthTarget + cellSpace)
        var roundedColumNb = columnNb.rounded(.down)
        if columnNb - roundedColumNb > 0.7 {
            roundedColumNb += 1
        }
        // largeur de la cellule
        return ((viewWidth - cellSpace) / roundedColumNb) - cellSpace
    }
}
