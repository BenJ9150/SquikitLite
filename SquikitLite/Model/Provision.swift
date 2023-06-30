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
    
    var product: Product
    var isFood: Bool
    var quantity: Double = 0
    var purchaseDate: Date = Date()
    let uuid: UUID
    
    // MARK: Init
    
    init(product: Product, isFood: Bool) {
        self.product = product
        self.isFood = isFood
        self.uuid = UUID.init()
    }
}
