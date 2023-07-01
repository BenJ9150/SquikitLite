//
//  Provision.swift
//  SquikitLite
//
//  Created by Benjamin on 22/06/2023.
//

import Foundation
import CoreData



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
}

