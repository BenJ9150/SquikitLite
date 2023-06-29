//
//  ProvisionCell.swift
//  SquikitLite
//
//  Created by Benjamin on 22/06/2023.
//

import UIKit



//===========================================================
// MARK: ProvisionCell class
//===========================================================



class ProvisionCell: UICollectionViewCell {

    // MARK: properties
    
    public static let key: String = "ProvisionCell"
    public static let nib: UINib = UINib(nibName: key, bundle: .main)
    
    // MARK: Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var qtyAndUnitLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var expirationButton: UIButton!
    @IBOutlet weak var background: UIView!
    
    // MARK: Draw
    
    override func draw(_ rect: CGRect) {
        background.addSmallShadow()
    }
}
