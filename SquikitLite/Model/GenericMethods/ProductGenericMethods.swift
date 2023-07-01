//
//  ProductsMethods.swift
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
        for product in ProductManager.shared.getProducts {
            let productDP = ProductDisplayProvider(forProduct: product)
            productsDP.append(productDP)
        }
        return productsDP
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
        default:
            return UIImage(named: "ic_rayon_autres")!
        }
    }
    /*
    public static UIImage GetDrawableId(decimal? a_categoryRef)
            {
                if(a_categoryRef == null)
                    return UIImage.FromBundle("ic_squikit");

                switch (a_categoryRef.Value)
                {
                    case 1:
                        return UIImage.FromBundle("ic_rayon_legumes");

                    case 1.5M:
                        return UIImage.FromBundle("ic_rayon_condiments_frais");

                    case 2:
                        return UIImage.FromBundle("ic_rayon_fruits");

                    case 2.5M:
                        return UIImage.FromBundle("ic_rayon_fruits_secs");

                    case 3:
                        return UIImage.FromBundle("ic_rayon_boucherie");

                    case 4:
                        return UIImage.FromBundle("ic_rayon_charcuterie");

                    case 5:
                        return UIImage.FromBundle("ic_rayon_traiteur");

                    case 6:
                        return UIImage.FromBundle("ic_rayon_poissonnerie");

                    case 7:
                        return UIImage.FromBundle("ic_rayon_cremerie");

                    case 7.5M:
                        return UIImage.FromBundle("ic_rayon_laits");

                    case 8:
                        return UIImage.FromBundle("ic_rayon_oeufs");

                    case 8.5M:
                        return UIImage.FromBundle("ic_rayon_dessert_frais");

                    case 9:
                        return UIImage.FromBundle("ic_rayon_huile_et_condiments");

                    case 10:
                        return UIImage.FromBundle("ic_rayon_feculents");

                    case 11:
                        return UIImage.FromBundle("ic_rayon_epicerie_salee");

                    case 11.5M:
                        return UIImage.FromBundle("ic_rayon_conserves");

                    case 12:
                        return UIImage.FromBundle("ic_rayon_produits_du_monde");

                    case 12.5M:
                        return UIImage.FromBundle("ic_rayon_petit_dejeuner");

                    case 13:
                        return UIImage.FromBundle("ic_rayon_epicerie_sucree");

                    case 13.5M:
                        return UIImage.FromBundle("ic_rayon_farines");

                    case 14:
                        return UIImage.FromBundle("ic_rayon_sucres");

                    case 14.5M:
                        return UIImage.FromBundle("ic_rayon_boulangerie");

                    case 15:
                        return UIImage.FromBundle("ic_rayon_boissons_sans_alcool");

                    case 16:
                        return UIImage.FromBundle("ic_rayon_biere_et_cidre");

                    case 16.5M:
                        return UIImage.FromBundle("ic_rayon_aperitifs_et_spiritieux");

                    case 17:
                        return UIImage.FromBundle("ic_rayon_vins");

                    case 18:
                        return UIImage.FromBundle("ic_rayon_surgeles");

                    //case 19:
                    //return Resource.Drawable.ic_rayon_bio;

                    case 20:
                        return UIImage.FromBundle("ic_rayon_enfants_et_bebes");

                    case 21:
                        return UIImage.FromBundle("ic_rayon_beaute_et_soin");

                    case 22:
                        return UIImage.FromBundle("ic_rayon_parapharmacie");

                    case 23:
                        return UIImage.FromBundle("ic_rayon_entretien_et_nettoyage");

                    case 24:
                        return UIImage.FromBundle("ic_rayon_essuie_tout_et_papier_toilette");

                    case 25:
                        return UIImage.FromBundle("ic_rayon_maison");

                    case 26:
                        return UIImage.FromBundle("ic_rayon_animalerie");

                    case 27:
                        return UIImage.FromBundle("ic_rayon_textile");

                    case 28:
                        return UIImage.FromBundle("ic_rayon_sport");

                    case 29:
                        return UIImage.FromBundle("ic_rayon_culture_et_loisirs");

                    case 30:
                        return UIImage.FromBundle("ic_rayon_multimedia");

                    case 31:
                        return UIImage.FromBundle("ic_rayon_electromenager");

                    case 32:
                        return UIImage.FromBundle("ic_rayon_bricolage_et_jardin");

                    case 33:
                        return UIImage.FromBundle("ic_rayon_automobile");

                    case 0:
                        return UIImage.FromBundle("ic_rayon_autres");

                    default:
                        return UIImage.FromBundle("ic_squikit");

                }
            }
    */
    
}
