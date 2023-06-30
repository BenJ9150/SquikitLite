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
    
    // MARK: Properties
    
    private var purchaseDateAtCreation = Date()
    let product: Product
    let isFood: Bool
    let uuid: UUID
    
    var purchaseDate: Date {
        return purchaseDateAtCreation
    }
    
    // MARK: Editable properties (by user)
    
    var quantity: Double
    var unit: String
    var customDlc: Date?
    var imageUrl: String?
    
    // MARK: Inits
    
    init(product: Product, isFood: Bool) {
        self.product = product
        self.isFood = isFood
        self.uuid = UUID.init()
        self.quantity = product.DefaultQuantity
        self.unit = product.ShoppingUnit
    }
    
    convenience init(cloneFromProvision prov: Provision) {
        self.init(product: prov.product, isFood: prov.isFood)
        
        // Editable properties
        self.quantity = prov.quantity
        self.unit = prov.unit
        self.customDlc = prov.customDlc
        self.imageUrl = prov.imageUrl
    }
}

