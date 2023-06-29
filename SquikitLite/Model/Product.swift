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
    
    var Id: String
    var Name: String
    var ShortName: String
    var Variants: String
    var Unit: String
    var ShoppingUnit: String
    var UnitConversionFactorGtoCAC: Double
    var UnitConversionFactorGtoCAS: Double
    var UnitConversionFactorGtoL: Double
    var UnitConversionFactorGtoPieces: Double
    var DefaultNote: String?
    var DefaultQuantity: Double
    var DefaultQuantityThreshold: Double
    var Thumbnail: String?
    var ThumbnailUrl: String?
    var Category: String?
    var SubCategory: String?
    var CategoryRef: Double
    var SubCategoryRef: Double
    var StorageZoneId: Int
    var Preservation: Int
    var PreservationAfterOpening: Int
    
}
