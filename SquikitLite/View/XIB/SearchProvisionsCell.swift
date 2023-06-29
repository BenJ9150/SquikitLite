//
//  SearchProvisionsCell.swift
//  SquikitLite
//
//  Created by Benjamin on 29/06/2023.
//

import UIKit

class SearchProvisionsCell: UITableViewCell {
    
    // MARK: properties
    
    public static let key: String = "SearchProvisionsCell"
    public static let nib: UINib = UINib(nibName: key, bundle: .main)
    
    // MARK: Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var addProvisionButton: UIButton!
    
    
    /*
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    */
}
