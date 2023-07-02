//
//  ShoppingCell.swift
//  SquikitLite
//
//  Created by Benjamin on 02/07/2023.
//

import UIKit

class ShoppingCell: UITableViewCell {

    // MARK: properties
    
    public static let key: String = "ShoppingCell"
    public static let nib: UINib = UINib(nibName: key, bundle: .main)
    
    // MARK: Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var qtyAndUnitLabel: UILabel!
    @IBOutlet weak var dlcLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var background: UIView!
    
    // MARK: Draw
    
    override func draw(_ rect: CGRect) {
        background.addSmallShadow()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
