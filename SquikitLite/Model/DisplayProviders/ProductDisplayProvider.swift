//
//  ProductDisplayProvider.swift
//  SquikitLite
//
//  Created by Benjamin on 28/06/2023.
//

import Foundation
import UIKit



//===========================================================
// MARK: ProductDisplayProvider class
//===========================================================



class ProductDisplayProvider {
    
    // MARK: Properties
    
    let product: Product
    
    // MARK: Init
    
    init(forProduct product: Product) {
        self.product = product
    }
}



//===========================================================
// MARK: Name and variants
//===========================================================



extension ProductDisplayProvider {
    
    var name: String {
        return product.Name.capitalizedSentence
    }
    
    var variants: [String.SubSequence] {
        if product.Variants == "" {
            return [String.SubSequence]()
        }
        // split
        return product.Variants.split(separator: ";")
    }
}



//===========================================================
// MARK: Product Image
//===========================================================



extension ProductDisplayProvider {
    
    var image: UIImage {
        return ProductGenericMethods.getDefaultImage(forCategoryRef: product.CategoryRef)
    }
}



//===========================================================
// MARK: Category and subCategory
//===========================================================



extension ProductDisplayProvider {
    
    var category: String {
        return ProductGenericMethods.getCategory(withRef: product.CategoryRef).capitalizedSentence
    }
    
    var subCategory: String {
        return ProductGenericMethods.getSubCategory(withSubCatRef: product.SubCategoryRef, inCatRef: product.CategoryRef)
    }
    
    var categoryAndSubCategory: String {
        return category + " / " + subCategory
    }
}
