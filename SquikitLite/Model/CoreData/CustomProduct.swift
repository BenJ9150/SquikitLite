//
//  CustomProduct.swift
//  SquikitLite
//
//  Created by Benjamin on 05/07/2023.
//

import Foundation
import CoreData



//===========================================================
// MARK: CustomProduct class
//===========================================================



class CustomProduct: NSManagedObject {
    
    static func getCustomProduct(fromID productId: String) -> [CustomProduct] {
        let request: NSFetchRequest<CustomProduct> = CustomProduct.fetchRequest()
        request.predicate = NSPredicate(format: "customProductId == %@", productId)
        request.fetchLimit = 1
        return fetchInContext(forRequest: request)
    }
}



//===========================================================
// MARK: Fetch
//===========================================================



extension CustomProduct {
    
    private static func fetchInContext(forRequest request: NSFetchRequest<CustomProduct>) -> [CustomProduct] {
        guard let customProducts = try? CoreDataStack.shared.viewContext.fetch(request) else {
            return []
        }
        return customProducts
    }
}
