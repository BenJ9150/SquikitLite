//
//  UserProvisionsManager.swift
//  SquikitLite
//
//  Created by Benjamin on 29/06/2023.
//

import Foundation



//===========================================================
// MARK: UserProvisionsManager class
//===========================================================



class UserProvisionsManager {
    
    // MARK: properties
    
    var provisions: [Provision] {
        return o_provisions
    }
    
    private lazy var o_provisions: [Provision] = {
        var provisions = [Provision]()
        
        for userProv in UserProvision.all {
            // get product
            guard let productId = userProv.productId else {continue}
            guard let product = ProductManager.getProduct(fromId: productId) else {continue}
            // Unwrapp userProv
            guard let purchaseDate = userProv.purchaseDate else {continue}
            guard let uuid = userProv.uuid else {continue}
            // add to provisions
            provisions.append(Provision(product: product, isFood: userProv.isFood, purchaseDate: purchaseDate, quantity: userProv.quantity, uuid: uuid))
        }
        return provisions
    }()
    
    // MARK: Singleton
    
    static let shared = UserProvisionsManager()
    private init() {}
}



//===========================================================
// MARK: save provisions
//===========================================================



extension UserProvisionsManager {
    
    func saveNewUserProvision(provision: Provision) {
        // add to current provisions
        o_provisions.append(provision)
        // save in coreData
        var userProv = UserProvision(context: CoreDataStack.shared.viewContext)
        saveOrUpdateUserProvision(userProv: &userProv, fromProvision: provision)
    }
    
    private func saveOrUpdateUserProvision(userProv: inout UserProvision, fromProvision provision: Provision) {
        userProv.isFood = provision.isFood
        userProv.productId = provision.product.Id
        userProv.purchaseDate = provision.purchaseDate
        userProv.quantity = provision.quantity
        userProv.uuid = provision.uuid
        
        do {
            try CoreDataStack.shared.viewContext.save()
        } catch let error {
            print(error)
        }
    }
}



//===========================================================
// MARK: delete provisions
//===========================================================



extension UserProvisionsManager {
    
    func deleteUserProvision(provision: Provision) {
        // delete from coreData
        if let userProv = UserProvision.getUserProvision(fromUUID: provision.uuid) {
            CoreDataStack.shared.viewContext.delete(userProv)
            do {
                try CoreDataStack.shared.viewContext.save()
            } catch let error {
                print(error)
            }
        }
        // delete to current provisions
        o_provisions.removeAll { $0.uuid == provision.uuid }
    }
}



//===========================================================
// MARK: update provisions
//===========================================================



extension UserProvisionsManager {
    
    func updateUserProvisions(provision: Provision) {
        // update in coreData
        if var userProv = UserProvision.getUserProvision(fromUUID: provision.uuid) {
            saveOrUpdateUserProvision(userProv: &userProv, fromProvision: provision)
        }
    }
}

