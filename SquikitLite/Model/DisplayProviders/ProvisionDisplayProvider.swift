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
    
    private let o_provision: Provision
    private var o_customProduct: CustomProduct?
    
    private lazy var product: Product? = { // lazy pour ne pas rechercher tout le temps dans les products (grosse base de données)
        return ProductManager.getProduct(fromId: o_provision.productId)
    }()
    
    var provision: Provision {
        return o_provision
    }
    
    // MARK: Init
    
    init(forProvision provision: Provision) {
        self.o_provision = provision
        if let productId = self.o_provision.productId {
            self.o_customProduct = CustomProduct.getCustomProduct(fromID: productId)
        }
        
    }
}



//===========================================================
// MARK: UUID, Name and variants
//===========================================================



extension ProvisionDisplayProvider {
    
    var uuid: UUID? {
        return o_provision.uuid
    }
    
    var name: String {
        guard let product = product else {return ""}
        return product.Name.capitalizedSentence
    }
    
    var variants: [String.SubSequence] {
        guard let product = product else {return [String.SubSequence]()}
        if product.Variants == "" {return [String.SubSequence]()}
        return product.Variants.split(separator: ";")
    }
}



//===========================================================
// MARK: Quantity and Unit
//===========================================================



extension ProvisionDisplayProvider {
    
    var quantity: Double {
        get {
            return o_provision.quantity
        } set {
            o_provision.quantity = newValue
        }
    }
    
    var quantityToString: String {
        if o_provision.quantity < 0 {return ""}
        return o_provision.quantity.toRoundedString
    }
    
    var unit: String {
        get {
            // custom
            if let custom = o_customProduct, let unit = custom.shoppingUnit {
                return unit
            }
            // generic
            guard let product = product else {return ""}
            return product.ShoppingUnit
        } set {
            if newValue == "" {return}
            if let custom = o_customProduct {
                custom.shoppingUnit = newValue
                CustomProduct.saveCustomProduct()
                return
            }
            // on crée un custom product
            guard var product = product else {return}
            product.ShoppingUnit = newValue
            o_customProduct = CustomProduct.addNewCustomProduct(fromProduct: product)
        }
    }
    
    var quantityAndShoppingUnit: String {
        if o_provision.quantity < 0 {return ""}
        if o_provision.quantity <= 1 {return quantityToString + " " + unit}
        
        return quantityToString + " " + ProductGenericMethods.getPluralUnit(ofUnit: unit)
    }
}



//===========================================================
// MARK: Product Image
//===========================================================



extension ProvisionDisplayProvider {
    
    var image: UIImage {
        // custom
        
        // generic
        guard let product = product else {return UIImage()}
        return ProductGenericMethods.getDefaultImage(forCategoryRef: product.CategoryRef)
    }
}


//===========================================================
// MARK: DLC
//===========================================================



extension ProvisionDisplayProvider {
    
    private var havePeremption: Bool {
        // custom
        if let custom = o_customProduct {
            if custom.preservation < 0 {return false}
            return true
        }
        // generic
        guard let product = product else {return false}
        if product.Preservation < 0 {return false}
        return true
    }
    
    private var preservation: Int {
        // custom
        if let custom = o_customProduct {
            return Int(custom.preservation)
        }
        // generic
        guard let product = product else {return 0}
        return product.Preservation
    }
    
    var dlc: Date? {
        get {
            if let customDlc = o_provision.customDlc {
                return customDlc
            }
            if !havePeremption {
                return nil
            }
            // on retourne la date d'achat + durée préservation
            guard let purchaseDate = o_provision.purchaseDate else {return nil}
            return Calendar.current.date(byAdding: .day, value: preservation, to: purchaseDate)
            
        } set {
            o_provision.customDlc = newValue
        }
    }
    
    var dlcToString: String {
        return ProvisionGenericMethods.dlcToString(fromDLC: dlc)
    }
    
    /// - returns: Int.max if no peremption, or number of days
    var expirationCountDown: Int {
        // vérif custom dlc
        if let customDlc = o_provision.customDlc {
            // on retourne dlc - date actuelle
            return Calendar.current.numberOfDaysBetween(from: Date(), to: customDlc)
        }
        // vérif si périssable
        if !havePeremption {
            return Int.max
        }
        // on retourne la préservation - nb jours depuis achat
        guard let purchaseDate = o_provision.purchaseDate else {return Int.max}
        return preservation - Calendar.current.numberOfDaysBetween(from: purchaseDate, to: Date())
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
        // custom
        if let custom = o_customProduct {
            return ProductGenericMethods.getCategory(withRef: custom.categoryRef).capitalizedSentence
        }
        // generic
        guard let product = product else {return ""}
        return ProductGenericMethods.getCategory(withRef: product.CategoryRef).capitalizedSentence
    }
    
    var subCategory: String {
        // custom
        if let custom = o_customProduct {
            return ProductGenericMethods.getCategory(withRef: custom.subCatagoryRef).capitalizedSentence
        }
        // generic
        guard let product = product else {return ""}
        return ProductGenericMethods.getSubCategory(withSubCatRef: product.SubCategoryRef, inCatRef: product.CategoryRef)
    }
    
    var categoryAndSubCategory: String {
        return category + " / " + subCategory
    }
}
