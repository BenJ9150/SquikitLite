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



class Provision: NSObject {
    
    // MARK: Properties
    
    var product: Product
    var isFood: Bool
    var quantity: Double = 0
    var purchaseDate: Date = Date()
    
    // MARK: Init
    
    init(product: Product, isFood: Bool) {
        self.product = product
        self.isFood = isFood
    }
    
    // MARK: Init for NSSecureCoding
    
    required convenience init(coder: NSCoder) {
        let product = coder.decodeObject(forKey: "product") as! Product
        let isFood = coder.decodeInteger(forKey: "isFood")
        let quantity = coder.decodeInteger(forKey: "quantity")
        let purchaseDate = coder.decodeInteger(forKey: "purchaseDate")
        
        self.init(product: product, isFood: (isFood != 0))
    }
}



//===========================================================
// MARK: NSSecureCoding
//===========================================================



extension Provision: NSSecureCoding {
    
    static var supportsSecureCoding = true
    
    func encode(with coder: NSCoder) {
        coder.encode(product, forKey: "product")
        coder.encode(isFood, forKey: "isFood")
        coder.encode(quantity, forKey: "quantity")
        coder.encode(purchaseDate, forKey: "purchaseDate")
    }
}
