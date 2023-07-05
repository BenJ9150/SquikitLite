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



//===========================================================
// MARK: New custom product
//===========================================================



extension CustomProduct {
    
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



extension CustomProduct {
    
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



extension CustomProduct {
    
    static func saveCustomProduct() {
        // update in coreData
        do {
            try CoreDataStack.shared.viewContext.save()
        } catch let error {
            print(error)
        }
    }
}
