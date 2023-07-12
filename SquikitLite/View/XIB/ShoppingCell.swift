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
    @IBOutlet weak var dlcImageView: UIImageView!
    
    // MARK: Draw
    
    override func draw(_ rect: CGRect) {
        background.addSmallShadow()
        background.layer.cornerRadius = (Dimensions.shoppingRowHeight - Dimensions.shoppingRowSpace)/2
        background.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        dlcImageView.image = UIImage(named: "ic_bsd_schedule")!.withTintColor(.quantityAndUnit)
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
