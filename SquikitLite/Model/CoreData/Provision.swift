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


enum ProvisionState: String {
    case inStock = "inStock"
    case inShop = "inShop"
    case inCart = "inCart"
    case inShopOrCart = "inShopOrCart"
}


class Provision: NSManagedObject {
    
    static var allInStock: [Provision] {
        let request: NSFetchRequest<Provision> = Provision.fetchRequest()
        request.predicate = NSPredicate(format: "state == %@", ProvisionState.inStock.rawValue)
        return fetchInContext(forRequest: request)
    }
    
    static var allInShop: [Provision] {
        let request: NSFetchRequest<Provision> = Provision.fetchRequest()
        request.predicate = NSPredicate(format: "state == %@", ProvisionState.inShop.rawValue)
        return fetchInContext(forRequest: request)
    }
    
    static var allInCart: [Provision] {
        let request: NSFetchRequest<Provision> = Provision.fetchRequest()
        request.predicate = NSPredicate(format: "state == %@", ProvisionState.inCart.rawValue)
        return fetchInContext(forRequest: request)
    }
    
    static var cartCount: Int {
        let request: NSFetchRequest<Provision> = Provision.fetchRequest()
        request.predicate = NSPredicate(format: "state == %@", ProvisionState.inCart.rawValue)
        guard let cartCount = try? CoreDataStack.shared.viewContext.count(for: request) else {
            return 0
        }
        return cartCount
    }
    
    static func getProvision(fromUUID uuid: UUID) -> [Provision] {
        let request: NSFetchRequest<Provision> = Provision.fetchRequest()
        request.predicate = NSPredicate(format: "uuid == %@", uuid as CVarArg)
        request.fetchLimit = 1
        return fetchInContext(forRequest: request)
    }
}



//===========================================================
// MARK: Fetch
//===========================================================



extension Provision {
    
    private static func fetchInContext(forRequest request: NSFetchRequest<Provision>) -> [Provision] {
        guard let userProvisions = try? CoreDataStack.shared.viewContext.fetch(request) else {
            return []
        }
        return userProvisions
    }
}
