//
//  Product.swift
//  SquikitLite
//
//  Created by Benjamin on 22/06/2023.
//

import Foundation



//===========================================================
// MARK: Product struct
//===========================================================



struct Product: Codable {
    
    // MARK: Customizable properties (in provision)
    
    let DefaultQuantity: Double
    let ShoppingUnit: String
    let Preservation: Int
    
    // MARK: Constant properties
    
    let Id: String
    let Name: String
    let ShortName: String
    let Variants: String
    let Unit: String
    let UnitConversionFactorGtoCAC: Double
    let UnitConversionFactorGtoCAS: Double
    let UnitConversionFactorGtoL: Double
    let UnitConversionFactorGtoPieces: Double
    let DefaultNote: String?
    let DefaultQuantityThreshold: Double
    let Thumbnail: String?
    let ThumbnailUrl: String?
    let Category: String?
    let SubCategory: String?
    let CategoryRef: Double
    let SubCategoryRef: Double
    let StorageZoneId: Int
    let PreservationAfterOpening: Int
}
