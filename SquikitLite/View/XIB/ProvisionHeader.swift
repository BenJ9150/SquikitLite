//
//  ProvisionHeader.swift
//  SquikitLite
//
//  Created by Benjamin on 04/07/2023.
//

import UIKit

class ProvisionHeader: UICollectionReusableView {

    // MARK: properties
    
    public static let key: String = "ProvisionHeader"
    public static let nib: UINib = UINib(nibName: key, bundle: .main)
    
    // MARK: Outlets
    
    @IBOutlet weak var headerLabel: UILabel!
    
}
