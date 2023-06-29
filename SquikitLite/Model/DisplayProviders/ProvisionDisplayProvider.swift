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
    
    private let provision: Provision
    
    private var product: Product {
        get {
            return provision.product
        }
    }
    
    // MARK: Init
    
    init(forProvision provision: Provision) {
        self.provision = provision
    }
}



//===========================================================
// MARK: Display providers
//===========================================================



extension ProvisionDisplayProvider {
    
    var name: String {
        return product.Name.capitalizedSentence
    }
    
    var quantityAndShoppingUnit: String {
        let roundedQty = provision.quantity.rounded()
        if roundedQty == provision.quantity {
            return "\(provision.quantity.formatted(.number.precision(.fractionLength(0))))" + " " + product.ShoppingUnit
        } else {
            return "\(provision.quantity.formatted(.number.precision(.fractionLength(1))))" + " " + product.ShoppingUnit
        }
    }
    
    var image: UIImage {
        return ProductsGenericMethods.getDefaultImage(forCategoryRef: product.CategoryRef)
    }
    
    var category: String {
        // TO DO
        return "ToDo"
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
        let nbOfDaysSincePurchase = Calendar.current.numberOfDaysBetween(from: provision.purchaseDate, to: Date())
        return product.Preservation - nbOfDaysSincePurchase
    }
    
    var stringExpirationCountDown: String {
        if !havePeremption || expirationCountDown == Int.max {
            return ""
        }
        
        if expirationCountDown < 0 {
            return "Périm."
        }
        if expirationCountDown == 0 {
            return "Auj."
        }
        if expirationCountDown >= 99 {
            return "+99j"
        }
        return "J-\(product.Preservation)"
    }
}
