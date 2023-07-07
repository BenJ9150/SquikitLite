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
    
    static func getCustomProduct(fromID productId: String) -> CustomProduct? {
        let request: NSFetchRequest<CustomProduct> = CustomProduct.fetchRequest()
        request.fetchLimit = 1

        if let customProduct = try? CoreDataStack.shared.viewContext.fetch(request).first(where: { $0.customProductId == productId }) {
            return customProduct
        }
        return nil
    }
}
