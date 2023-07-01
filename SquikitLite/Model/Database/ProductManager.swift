//
//  ProvisionManager.swift
//  SquikitLite
//
//  Created by Benjamin on 22/06/2023.
//

import Foundation



//===========================================================
// MARK: ProductManager class
//===========================================================



class ProductManager {
    
    // MARK: Properties
    
    private var products = [Product]()
    
    var getProducts: [Product] {
        return products
    }
    
    var count: Int {
        return products.count
    }
    
    // MARK: Singleton
    
    static let shared = ProductManager()
    
    private init() {
        getFoodsAndNoFoods()
    }
}



//===========================================================
// MARK: Methods get products
//===========================================================



extension ProductManager {
    
    private func getFoodsAndNoFoods() {
        // foods
        getProductsFromFile(fileName: AppSettings.foodsCollectionFileName) { foods in
            self.products.append(contentsOf: foods)
        }
        // noFoods
        getProductsFromFile(fileName: AppSettings.noFoodsCollectionFileName) { noFoods in
            self.products.append(contentsOf: noFoods)
        }
    }
    
    private func getProductsFromFile(fileName: String, completionHandler: @escaping ([Product]) -> ()) {
        // base pour pouvoir récupérer depuis un serveur
        // pour l'instant on reste en local
        return completionHandler(productsJsonDecoder(withFile: fileName))
    }
    
    private func productsJsonDecoder(withFile fileName: String) -> [Product] {
        guard let pathfile = Bundle.main.path(forResource: fileName, ofType: "json") else {
            return [Product]()
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: pathfile), options: .mappedIfSafe)
            return try JSONDecoder().decode([Product].self, from: data)
        } catch let error {
            print(error)
            return [Product]()
        }
    }
}
