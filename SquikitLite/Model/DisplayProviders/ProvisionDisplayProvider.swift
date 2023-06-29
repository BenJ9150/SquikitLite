//
//  ProvisionDisplayProvider.swift
//  SquikitLite
//
//  Created by Benjamin on 28/06/2023.
//

import Foundation
import UIKit



//===========================================================
// MARK: ProvisionDisplayProvider class
//===========================================================



class ProvisionDisplayProvider {
    
    // MARK: Properties
    
    private let provOfDisplayProvider: Provision
    
    private var product: Product {
        return provOfDisplayProvider.product
    }
    
    var provision: Provision {
        return provOfDisplayProvider
    }
    
    // MARK: Init
    
    init(forProvision provision: Provision) {
        self.provOfDisplayProvider = provision
    }
}



//===========================================================
// MARK: ID, Name and variants
//===========================================================



extension ProvisionDisplayProvider {
    
    var productId: String {
        return product.Id
    }
    
    var name: String {
        return product.Name.capitalizedSentence
    }
    
    var variants: [String.SubSequence] {
        if product.Variants == "" {
            return [String.SubSequence]()
        }
        // split
        return product.Variants.split(separator: ";")
    }
}



//===========================================================
// MARK: Quantity and Unit
//===========================================================



extension ProvisionDisplayProvider {
    
    var quantityAndShoppingUnit: String {
        let roundedQty = provOfDisplayProvider.quantity.rounded()
        if roundedQty == provOfDisplayProvider.quantity {
            return "\(provOfDisplayProvider.quantity.formatted(.number.precision(.fractionLength(0))))" + " " + product.ShoppingUnit
        } else {
            return "\(provOfDisplayProvider.quantity.formatted(.number.precision(.fractionLength(1))))" + " " + product.ShoppingUnit
        }
    }
}



//===========================================================
// MARK: Product Image
//===========================================================



extension ProvisionDisplayProvider {
    
    var image: UIImage {
        return ProductsGenericMethods.getDefaultImage(forCategoryRef: product.CategoryRef)
    }
}


//===========================================================
// MARK: DLC
//===========================================================



extension ProvisionDisplayProvider {
    
    var havePeremption: Bool {
        if product.Preservation < 0 {
            return false
        }
        return true
    }
    
    /// - returns: Int.max if error, or number of days
    var expirationCountDown: Int {
        if !havePeremption {
            return Int.max
        }
        let nbOfDaysSincePurchase = Calendar.current.numberOfDaysBetween(from: provOfDisplayProvider.purchaseDate, to: Date())
        return product.Preservation - nbOfDaysSincePurchase
    }
    
    var stringExpirationCountDown: String {
        if !havePeremption || expirationCountDown == Int.max {
            return ""
        }
        
        if expirationCountDown < 0 {
            return NSLocalizedString("dlcLabel_outdated", comment: "")
        }
        if expirationCountDown == 0 {
            return NSLocalizedString("dlcLabel_today", comment: "")
        }
        if expirationCountDown >= 99 {
            return NSLocalizedString("dlcLabel_longTime", comment: "")
        }
        return NSLocalizedString("dlcLabel_day", comment: "") + "\(product.Preservation)"
    }
}



//===========================================================
// MARK: Category and subCategory
//===========================================================



extension ProvisionDisplayProvider {
    
    var category: String {
        return ProductsGenericMethods.getCategory(withRef: product.CategoryRef).capitalizedSentence
    }
    
    var subCategory: String {
        return ProductsGenericMethods.getSubCategory(withSubCatRef: product.SubCategoryRef, inCatRef: product.CategoryRef)
    }
    
    var categoryAndSubCategory: String {
        return category + " / " + subCategory
    }
}
