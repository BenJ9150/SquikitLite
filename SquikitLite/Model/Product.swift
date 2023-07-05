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
    
    var isCustom: Bool = false // new par rapport aux JSON, à vérifier lors de la sauvegarde d'une provision dans coreData
    
    // MARK: Customizable properties (saved in customProduct)
    
    var DefaultQuantity: Double
    var CategoryRef: Double
    var SubCategoryRef: Double
    var ShoppingUnit: String
    var Preservation: Int
    var PreservationAfterOpening: Int
    var DefaultNote: String?
    var StorageZoneId: Int
    var ThumbnailUrl: String?
    var ShoppingNote: String? // new par rapport aux JSON
    
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
    let DefaultQuantityThreshold: Double
    let Thumbnail: String?
    let Category: String?
    let SubCategory: String?
    
    // MARK: Init
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isCustom = false
        self.DefaultQuantity = try container.decode(Double.self, forKey: .DefaultQuantity)
        self.CategoryRef = try container.decode(Double.self, forKey: .CategoryRef)
        self.SubCategoryRef = try container.decode(Double.self, forKey: .SubCategoryRef)
        self.ShoppingUnit = try container.decode(String.self, forKey: .ShoppingUnit)
        self.Preservation = try container.decode(Int.self, forKey: .Preservation)
        self.PreservationAfterOpening = try container.decode(Int.self, forKey: .PreservationAfterOpening)
        self.DefaultNote = try container.decodeIfPresent(String.self, forKey: .DefaultNote)
        self.StorageZoneId = try container.decode(Int.self, forKey: .StorageZoneId)
        self.ThumbnailUrl = try container.decodeIfPresent(String.self, forKey: .ThumbnailUrl)
        self.ShoppingNote = nil
        self.Id = try container.decode(String.self, forKey: .Id)
        self.Name = try container.decode(String.self, forKey: .Name)
        self.ShortName = try container.decode(String.self, forKey: .ShortName)
        self.Variants = try container.decode(String.self, forKey: .Variants)
        self.Unit = try container.decode(String.self, forKey: .Unit)
        self.UnitConversionFactorGtoCAC = try container.decode(Double.self, forKey: .UnitConversionFactorGtoCAC)
        self.UnitConversionFactorGtoCAS = try container.decode(Double.self, forKey: .UnitConversionFactorGtoCAS)
        self.UnitConversionFactorGtoL = try container.decode(Double.self, forKey: .UnitConversionFactorGtoL)
        self.UnitConversionFactorGtoPieces = try container.decode(Double.self, forKey: .UnitConversionFactorGtoPieces)
        self.DefaultQuantityThreshold = try container.decode(Double.self, forKey: .DefaultQuantityThreshold)
        self.Thumbnail = try container.decodeIfPresent(String.self, forKey: .Thumbnail)
        self.Category = try container.decodeIfPresent(String.self, forKey: .Category)
        self.SubCategory = try container.decodeIfPresent(String.self, forKey: .SubCategory)
    }
}
