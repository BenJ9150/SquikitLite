//
//  Categories.swift
//  SquikitLite
//
//  Created by Benjamin on 29/06/2023.
//

import Foundation


//===========================================================
// MARK: Categories class
//===========================================================



class Categories {
    
    // MARK: Properties
    
    private var categoriesDico = [Double: String]() // [CatRef: nameOfSubCat]
    private var subCategoriesDico = [Double: [Double: String]]() // [CatRef: [SubCatRef: nameOfSubCat]]
    
    var categories: [Double: String] {
        return categoriesDico
    }
    
    var subCategories: [Double: [Double: String]] {
        return subCategoriesDico
    }
    
    // MARK: Singleton
    
    static let shared = Categories()
    
    private init() {
        getCategories()
        getSubCategories()
    }
}



//===========================================================
// MARK: Methods
//===========================================================



extension Categories {
    
    private func getCategories() {
        let splitSource = NSLocalizedString("category_list", comment: "").split(separator: ",")
        if splitSource.count <= 0 {return}
        
        for value in splitSource {
            
            let splitValue = value.split(separator: ":") // split result: [catRef, name]
            if splitValue.count != 2 {continue}
            
            // get catRef
            if let catRef = Double(String(splitValue[0])) {
                // add to dico
                categoriesDico[catRef] = String(splitValue[1])
            }
        }
    }
    
    private func getSubCategories() {
        let splitSource = NSLocalizedString("sub_category_list", comment: "").split(separator: ",")
        if splitSource.count <= 0 {return}
        
        for value in splitSource {
            
            // split références / subCatName
            let splitValue = value.split(separator: ":") // split result: [catRef-subCatRef, name]
            if splitValue.count != 2 {continue}
            
            // split les références
            let splitRef = splitValue[0].split(separator: "-") // split result: [catRef, subCatRef]
            if splitRef.count != 2 {continue}
            
            // récup des références
            guard let catRef = Double(String(splitRef[0])), let subCatRef = Double(String(splitRef[1])) else {continue}
            
            // add to dico
            let dicoContainsKey = subCategoriesDico.contains { $0.key == catRef }
            if dicoContainsKey {
                subCategoriesDico[catRef]?.updateValue(String(splitValue[1]), forKey: subCatRef)
            } else {
                subCategoriesDico[catRef] = [subCatRef: String(splitValue[1])]
            }
        }
    }
}
