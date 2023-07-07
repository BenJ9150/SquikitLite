//
//  ProductGenericMethods.swift
//  SquikitLite
//
//  Created by Benjamin on 28/06/2023.
//

import Foundation
import UIKit



//===========================================================
// MARK: ProductGenericMethods class
//===========================================================



class ProductGenericMethods {
    
    static func productsDisplayProviderFromDatabase() -> [ProductDisplayProvider] {
        var productsDP = [ProductDisplayProvider]()
        for product in ProductManager.shared.products {
            let productDP = ProductDisplayProvider(forProduct: product)
            productsDP.append(productDP)
        }
        return productsDP
    }
}




//===========================================================
// MARK: New custom product
//===========================================================



extension ProductGenericMethods {
    
    static func addNewCustomProduct(fromProduct product: Product) -> CustomProduct? {
        let customProduct = CustomProduct(context: CoreDataStack.shared.viewContext)
        // add values
        customProduct.customProductId = product.Id
        customProduct.categoryRef = product.CategoryRef
        customProduct.defaultNote = product.DefaultNote
        customProduct.defaultQuantity = product.DefaultQuantity
        customProduct.preservation = Int32(product.Preservation)
        customProduct.preservationAfterOpening = Int32(product.PreservationAfterOpening)
        customProduct.shoppingNote = product.ShoppingNote
        customProduct.shoppingUnit = product.ShoppingUnit
        customProduct.storageZoneId = Int32(product.StorageZoneId)
        customProduct.subCatagoryRef = product.SubCategoryRef
        customProduct.thumbnailUrl = product.ThumbnailUrl
        
        do {
            try CoreDataStack.shared.viewContext.save()
        } catch let error {
            print(error)
            return nil
        }
        print("new customProduct added: \(product.Name)")
        return customProduct
    }
}



//===========================================================
// MARK: delete custom product
//===========================================================



extension ProductGenericMethods {
    
    static func deleteCustomProduct(_ customProduct: CustomProduct) {
        // delete from coreData
        CoreDataStack.shared.viewContext.delete(customProduct)
        do {
            try CoreDataStack.shared.viewContext.save()
        } catch let error {
            print(error)
        }
    }
}



//===========================================================
// MARK: update custom product
//===========================================================



extension ProductGenericMethods {
    
    static func saveCustomProduct() {
        // update in coreData
        do {
            try CoreDataStack.shared.viewContext.save()
        } catch let error {
            print(error)
        }
    }
}



//===========================================================
// MARK: Categories, subCategories
//===========================================================



extension ProductGenericMethods {
    
    static func getCategory(withRef ref: Double) -> String {
        if let cat = Categories.shared.categories[ref] {
            return cat
        }
        return ""
    }
    
    static func getSubCategory(withSubCatRef subCatRef: Double, inCatRef catRef: Double) -> String {
        guard let subCatDico = Categories.shared.subCategories[catRef] else {return ""}
        
        if let subCat = subCatDico[subCatRef] {
            return subCat
        }
        return ""
    }
}



//===========================================================
// MARK: Units
//===========================================================



extension ProductGenericMethods {
    
    static func getUnitsCount() -> Int {
        return Units.shared.units.count
    }
    
    static func getUnit(ofRow row: Int) -> String {
        if row < Units.shared.units.count {
            return Units.shared.units[row]
        }
        return ""
    }
    
    static func getUnitRow(ofUnit unit: String) -> Int {
        if let row = Units.shared.units.firstIndex(where: { $0.cleanUpForComparaison == unit.cleanUpForComparaison }) {
            return row
        }
        return 0
    }
    
    static func getPluralUnit(ofUnit unit: String) -> String {
        if unit == "" {return ""}
        
        if let keyValue = Units.shared.unitsSingPlural.keys.first(where: { $0.cleanUpForComparaison == unit.cleanUpForComparaison }) {
            if let pluralUnit = Units.shared.unitsSingPlural[keyValue] {
                return pluralUnit
            }
        }
        return unit
    }
}



//===========================================================
// MARK: Filters
//===========================================================



extension ProductGenericMethods {
    
    static func filterProductsByName(fromProductsDP productsDP: [ProductDisplayProvider], withText searchText: String) -> [ProductDisplayProvider] {
        
        if searchText == "" {
            return productsDP
        }
        
        var searchedProvsProvider = productsDP.filter({ provProvider in
            // name
            if provProvider.name.cleanUpForComparaison.prefix(searchText.count) == searchText.cleanUpForComparaison {
                return true
            }
            // subCat
            if provProvider.subCategory.cleanUpForComparaison.prefix(searchText.count) == searchText.cleanUpForComparaison {
                return true
            }
            // variants
            for variant in provProvider.variants {
                if String(variant).cleanUpForComparaison.prefix(searchText.count) == searchText.cleanUpForComparaison {
                    return true
                }
            }
            // cat
            if provProvider.category.cleanUpForComparaison.prefix(searchText.count) == searchText.cleanUpForComparaison {
                return true
            }
            return false
        })
        
        searchedProvsProvider.sort { $0.name.count < $1.name.count }
        
        return searchedProvsProvider
    }
}



//===========================================================
// MARK: Images
//===========================================================



extension ProductGenericMethods {
    
    static func getDefaultImage(forCategoryRef categoryRef: Double) -> UIImage {
        switch categoryRef {
        case 1:
            return UIImage(named: "ic_rayon_legumes")!

        case 1.5:
            return UIImage(named: "ic_rayon_condiments_frais")!

        case 2:
            return UIImage(named: "ic_rayon_fruits")!

        case 2.5:
            return UIImage(named: "ic_rayon_fruits_secs")!

        case 3:
            return UIImage(named: "ic_rayon_boucherie")!

        case 4:
            return UIImage(named: "ic_rayon_charcuterie")!

        case 5:
            return UIImage(named: "ic_rayon_traiteur")!

        case 6:
            return UIImage(named: "ic_rayon_poissonnerie")!

        case 7:
            return UIImage(named: "ic_rayon_cremerie")!

        case 7.5:
            return UIImage(named: "ic_rayon_laits")!

        case 8:
            return UIImage(named: "ic_rayon_oeufs")!

        case 8.5:
            return UIImage(named: "ic_rayon_dessert_frais")!

        case 9:
            return UIImage(named: "ic_rayon_huile_et_condiments")!

        case 10:
            return UIImage(named: "ic_rayon_feculents")!

        case 11:
            return UIImage(named: "ic_rayon_epicerie_salee")!

        case 11.5:
            return UIImage(named: "ic_rayon_conserves")!

        case 12:
            return UIImage(named: "ic_rayon_produits_du_monde")!

        case 12.5:
            return UIImage(named: "ic_rayon_petit_dejeuner")!

        case 13:
            return UIImage(named: "ic_rayon_epicerie_sucree")!

        case 13.5:
            return UIImage(named: "ic_rayon_farines")!

        case 14:
            return UIImage(named: "ic_rayon_sucres")!

        case 14.5:
            return UIImage(named: "ic_rayon_boulangerie")!

        case 15:
            return UIImage(named: "ic_rayon_boissons_sans_alcool")!

        case 16:
            return UIImage(named: "ic_rayon_biere_et_cidre")!

        case 16.5:
            return UIImage(named: "ic_rayon_aperitifs_et_spiritieux")!

        case 17:
            return UIImage(named: "ic_rayon_vin_et_spiritueux")!

        case 18:
            return UIImage(named: "ic_rayon_surgeles")!

        //case 19:
        //return Resource.Drawable.ic_rayon_bio!

        case 20:
            return UIImage(named: "ic_rayon_enfants_et_bebe")!

        case 21:
            return UIImage(named: "ic_rayon_beaute_et_soin")!

        case 22:
            return UIImage(named: "ic_rayon_parapharmacie")!

        case 23:
            return UIImage(named: "ic_rayon_entretien_et_nettoyage")!

        case 24:
            return UIImage(named: "ic_rayon_essuie_tout_et_papier_toilette")!

        case 25:
            return UIImage(named: "ic_rayon_maison")!

        case 26:
            return UIImage(named: "ic_rayon_animalerie")!

        case 27:
            return UIImage(named: "ic_rayon_textile")!

        case 28:
            return UIImage(named: "ic_rayon_sport")!

        case 29:
            return UIImage(named: "ic_rayon_culture_et_loisirs")!

        case 30:
            return UIImage(named: "ic_rayon_multimedia")!

        case 31:
            return UIImage(named: "ic_rayon_electromenager")!

        case 32:
            return UIImage(named: "ic_rayon_bricolage_et_jardin")!

        case 33:
            return UIImage(named: "ic_rayon_automobile")!

        case 0:
            return UIImage(named: "ic_rayon_autres")!
            
        default:
            return UIImage(named: "ic_rayon_autres")!
        }
    }
}
