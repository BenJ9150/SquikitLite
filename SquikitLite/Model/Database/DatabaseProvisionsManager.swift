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



class DatabaseProvisionsManager {
    
    // MARK: Properties
    
    private let foodsCollectionFileName = "foodsCollection"
    private let noFoodsCollectionFileName = "nofoodsCollection"
    private var provisions = [Provision]()
    
    var dataBaseProvisions: [Provision] {
        return provisions
    }
    
    var count: Int {
        return provisions.count
    }
    
    // MARK: Singleton
    
    static let shared = DatabaseProvisionsManager()
    
    private init() {
        getProvisionsFromFood()
        getProvisionsFromNoFood()
    }
}



//===========================================================
// MARK: Methods get provisions
//===========================================================



extension DatabaseProvisionsManager {
    
    private func getProvisionsFromFood() {
        getFood { products in
            if products.count <= 0 {return}
            
            for product in products {
                self.provisions.append(Provision(product: product, isFood: true))
            }
        }
    }
    
    private func getProvisionsFromNoFood() {
        getNoFood { products in
            if products.count <= 0 {return}
            
            for product in products {
                self.provisions.append(Provision(product: product, isFood: false))
            }
        }
    }
}


//===========================================================
// MARK: Methods get products
//===========================================================



extension DatabaseProvisionsManager {
    
    private func getFood(completionHandler: @escaping ([Product]) -> ()) {
        // base pour pouvoir récupérer depuis un serveur
        // pour l'instant on reste en local
        return completionHandler(productsJsonDecoder(withFile: foodsCollectionFileName))
    }
    
    private func getNoFood(completionHandler: @escaping ([Product]) -> ()) {
        // base pour pouvoir récupérer depuis un serveur
        // pour l'instant on reste en local
        return completionHandler(productsJsonDecoder(withFile: noFoodsCollectionFileName))
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
