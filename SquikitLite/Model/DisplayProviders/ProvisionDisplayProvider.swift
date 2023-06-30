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
        return provision.product
    }
    
    var provOfDisplayProvider: Provision {
        return provision
    }
    
    // MARK: Init
    
    init(forProvision provision: Provision) {
        self.provision = provision
    }
}



//===========================================================
// MARK: UUID, Name and variants
//===========================================================



extension ProvisionDisplayProvider {
    
    var uuid: UUID {
        return provision.uuid
    }
    
    var uuidToString: String {
        return provision.uuid.uuidString
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
    
    var quantity: Double {
        get {
            return provision.quantity
        } set {
            provision.quantity = newValue
        }
    }
    
    var quantityToString: String {
        if provision.quantity < 0 {return ""}
        return provision.quantity.toRoundedString
    }
    
    var unit: String {
        get {
            return provision.unit
        } set {
            if newValue != "" {
                provision.unit = newValue
            }
        }
    }
    
    var quantityAndShoppingUnit: String {
        if provision.quantity < 0 {return ""}
        if provision.quantity <= 1 {return quantityToString + " " + unit}
        
        return quantityToString + " " + ProductsGenericMethods.getPluralUnit(ofUnit: unit)
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
    
    var customDlc: Date? {
        get {
            return provision.customDlc
        } set {
            provision.customDlc = newValue
        }
    }
    
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
            return NSLocalizedString("dlcLabel_outdated", comment: "")
        }
        if expirationCountDown == 0 {
            return NSLocalizedString("dlcLabel_today", comment: "")
        }
        if expirationCountDown >= 99 {
            return NSLocalizedString("dlcLabel_longTime", comment: "")
        }
        return NSLocalizedString("dlcLabel_day", comment: "") + "\(expirationCountDown)"
    }
    
    var dlcToString: String {
        // date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = AppSettings.dateFormat
        
        // vérif si custom dlc
        if let customDlc = provision.customDlc {
            return NSLocalizedString("dlcSuffixString", comment: "") + dateFormatter.string(from: customDlc)
        }
        
        // vérif si product avec péremption
        if !havePeremption {
            return NSLocalizedString("dlcNoPeremptionMessage", comment: "")
        }
        // add preservation to purchase date
        var perempDate = provision.purchaseDate
        perempDate.addTimeInterval(Double(product.Preservation))
        
        return NSLocalizedString("dlcSuffixString", comment: "") + dateFormatter.string(from: perempDate)
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
