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
    var UnitConversionFactorGtoCAC: Decimal
    var UnitConversionFactorGtoCAS: Decimal
    var UnitConversionFactorGtoL: Decimal
    var UnitConversionFactorGtoPieces: Decimal
    var DefaultNote: String?
    var DefaultQuantity: Decimal
    var DefaultQuantityThreshold: Decimal
    var Thumbnail: String?
    var ThumbnailUrl: String?
    var Category: String?
    var SubCategory: String?
    var CategoryRef: Decimal
    var SubCategoryRef: Decimal
    var StorageZoneId: Int
    var Preservation: Int
    var PreservationAfterOpening: Int
    
}
