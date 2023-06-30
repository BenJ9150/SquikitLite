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
    
    let Id: String
    let Name: String
    let ShortName: String
    let Variants: String
    let Unit: String
    let ShoppingUnit: String
    let UnitConversionFactorGtoCAC: Double
    let UnitConversionFactorGtoCAS: Double
    let UnitConversionFactorGtoL: Double
    let UnitConversionFactorGtoPieces: Double
    let DefaultNote: String?
    let DefaultQuantity: Double
    let DefaultQuantityThreshold: Double
    let Thumbnail: String?
    let ThumbnailUrl: String?
    let Category: String?
    let SubCategory: String?
    let CategoryRef: Double
    let SubCategoryRef: Double
    let StorageZoneId: Int
    let Preservation: Int
    let PreservationAfterOpening: Int
}
