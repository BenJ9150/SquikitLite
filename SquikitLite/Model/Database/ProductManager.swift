//
//  ProductManager.swift
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
    
    var products: [Product] {
        return o_products
    }
    
    private lazy var o_products: [Product] = {
        var products = [Product]()
        // foods
        getProductsFromFile(fileName: AppSettings.foodsCollectionFileName) { foods in
            products.append(contentsOf: foods)
        }
        // noFoods
        getProductsFromFile(fileName: AppSettings.noFoodsCollectionFileName) { noFoods in
            products.append(contentsOf: noFoods)
        }
        return products
    }()
    
    
    // MARK: Singleton
    
    static let shared = ProductManager()
    private init() {}
}



//===========================================================
// MARK: Methods get products
//===========================================================



extension ProductManager {
    
    static func getProduct(fromId productId: String) -> Product? {
        guard var product = ProductManager.shared.o_products.first(where: { $0.Id == productId }) else {
            return nil
        }
        
        // on vérifie si product présent dans CustomProduct
        if let customProduct = CustomProduct.getCustomProduct(fromID: productId) {
            product.isCustom = true
            // on update les valeurs
            if let unit = customProduct.shoppingUnit { product.ShoppingUnit = unit }
            // TODO le reste...
        }
        return product
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
