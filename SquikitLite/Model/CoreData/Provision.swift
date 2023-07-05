//
//  Provision.swift
//  SquikitLite
//
//  Created by Benjamin on 04/07/2023.
//

import Foundation
import CoreData



//===========================================================
// MARK: Provision class
//===========================================================



class Provision: NSManagedObject {
    
    static var all: [Provision] {
        let request: NSFetchRequest<Provision> = Provision.fetchRequest()
        guard let userProvisions = try? CoreDataStack.shared.viewContext.fetch(request) else {
            return []
        }
        return userProvisions
    }
}



//===========================================================
// MARK: New provisions
//===========================================================



extension Provision {
    
    static func addNewProvision(fromProduct product: Product) -> Provision? {
        let userProv = Provision(context: CoreDataStack.shared.viewContext)
        // is food ?
        let isFood = !AppSettings.noFoodsRef.contains { $0 == product.CategoryRef }
        // add values
        userProv.isFood = isFood
        userProv.productId = product.Id
        userProv.purchaseDate = Date()
        userProv.quantity = product.DefaultQuantity
        userProv.uuid = UUID.init()
        
        do {
            try CoreDataStack.shared.viewContext.save()
        } catch let error {
            print(error)
            return nil
        }
        return userProv
    }
}



//===========================================================
// MARK: delete provisions
//===========================================================



extension Provision {
    
    static func deleteProvision(_ provision: Provision) -> Bool {
        // delete from coreData
        CoreDataStack.shared.viewContext.delete(provision)
        do {
            try CoreDataStack.shared.viewContext.save()
        } catch let error {
            print(error)
            return false
        }
        return true
    }
}



//===========================================================
// MARK: update provisions
//===========================================================



extension Provision {
    
    static func updateProvisions() -> Bool {
        // update in coreData
        do {
            try CoreDataStack.shared.viewContext.save()
        } catch let error {
            print(error)
            return false
        }
        return true
    }
}



//===========================================================
// MARK: Check provision in stock
//===========================================================



extension Provision {
    
    static func checkIfProductAlreadyAdded(withProductId productId: String) -> Bool {
        return Provision.all.contains { $0.productId == productId }
    }
}
