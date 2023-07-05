//
//  Provision.swift
//  SquikitLite
//
//  Created by Benjamin on 22/06/2023.
//

import Foundation



//===========================================================
// MARK: Provision class
//===========================================================



class Provision: Codable {
    
    // MARK: Public properties
    
    let purchaseDate: Date
    let isFood: Bool
    let uuid: UUID
    
    var quantity: Double
    var customDlc: Date?
    
    var product: Product {
        return o_product
    }
    
    // MARK: Private properties
    
    private var o_product: Product
    
    // MARK: Private customizable properties of product
    
    private var defaultQuantity: Double?
    private var categoryRef: Double?
    private var subCategoryRef: Double?
    private var o_shoppingUnit: String?
    private var preservation: Int?
    private var preservationAfterOpening: Int?
    private var defaultNote: String?
    private var storageZoneId: Int?
    private var thumbnailUrl: String?
    private var shoppingNote: String?
    
    // MARK: Inits
    
    init(product: Product, isFood: Bool, purchaseDate: Date, quantity: Double, uuid: UUID) {
        self.o_product = product
        self.isFood = isFood
        self.purchaseDate = purchaseDate
        self.uuid = uuid
        self.quantity = quantity
    }
}



//===========================================================
// MARK: Edit customizable properties of product
//===========================================================



extension Provision {
    
    var shoppingUnit: String? {
        get { return o_shoppingUnit}
        set {
            if let unit = newValue, unit != "" {
                o_product.isCustom = true
                o_shoppingUnit = unit
            }
        }
    }
    
    // TODO le reste...
}
