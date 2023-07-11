//
//  MultipleProductsChoiceCell.swift
//  SquikitLite
//
//  Created by Benjamin on 10/07/2023.
//

import UIKit

class MultipleProductsChoiceCell: UICollectionViewCell {

    // MARK: properties
    
    public static let key: String = "MultipleProductsChoiceCell"
    public static let nib: UINib = UINib(nibName: key, bundle: .main)
    
    // MARK: Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var background: UIView!    
    
    // MARK: Draw
    
    override func draw(_ rect: CGRect) {
        background.addSmallShadow()
    }
    
}
