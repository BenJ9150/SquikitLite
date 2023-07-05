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
            if let unit = provision.shoppingUnit {
                return unit
            }
            return product.ShoppingUnit
        } set {
            if newValue != "" {
                provision.shoppingUnit = newValue
            }
        }
    }
    
    var quantityAndShoppingUnit: String {
        if provision.quantity < 0 {return ""}
        if provision.quantity <= 1 {return quantityToString + " " + unit}
        
        return quantityToString + " " + ProductGenericMethods.getPluralUnit(ofUnit: unit)
    }
}



//===========================================================
// MARK: Product Image
//===========================================================



extension ProvisionDisplayProvider {
    
    var image: UIImage {
        return ProductGenericMethods.getDefaultImage(forCategoryRef: product.CategoryRef)
    }
}


//===========================================================
// MARK: DLC
//===========================================================



extension ProvisionDisplayProvider {
    
    private var havePeremption: Bool {
        if product.Preservation < 0 {
            return false
        }
        return true
    }
    
    var dlc: Date? {
        get {
            if let customDlc = provision.customDlc {
                return customDlc
            }
            if !havePeremption {
                return nil
            }
            // on retourne la date d'achat + durée préservation
            return Calendar.current.date(byAdding: .day, value: product.Preservation, to: provision.purchaseDate)
            
        } set {
            provision.customDlc = newValue
        }
    }
    
    var dlcToString: String {
        return ProvisionGenericMethods.dlcToString(fromDLC: dlc)
    }
    
    /// - returns: Int.max if no peremption, or number of days
    var expirationCountDown: Int {
        // vérif custom dlc
        if let customDlc = provision.customDlc {
            // on retourne dlc - date actuelle
            return Calendar.current.numberOfDaysBetween(from: Date(), to: customDlc)
        }
        // vérif si périssable
        if !havePeremption {
            return Int.max
        }
        // on retourne la préservation - nb jours depuis achat
        return product.Preservation - Calendar.current.numberOfDaysBetween(from: provision.purchaseDate, to: Date())
    }
    
    var stringExpirationCountDown: String {
        if expirationCountDown == Int.max {
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
}



//===========================================================
// MARK: Category and subCategory
//===========================================================



extension ProvisionDisplayProvider {
    
    var category: String {
        return ProductGenericMethods.getCategory(withRef: product.CategoryRef).capitalizedSentence
    }
    
    var subCategory: String {
        return ProductGenericMethods.getSubCategory(withSubCatRef: product.SubCategoryRef, inCatRef: product.CategoryRef)
    }
    
    var categoryAndSubCategory: String {
        return category + " / " + subCategory
    }
}
