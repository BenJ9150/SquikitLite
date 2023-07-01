//
//  ProvisionsGenericMethods.swift
//  SquikitLite
//
//  Created by Benjamin on 28/06/2023.
//

import Foundation



//===========================================================
// MARK: ProvisionGenericMethods class
//===========================================================



class ProvisionGenericMethods {
    
    static func getProvisionsDisplayProvider(forProvisions provisions: [Provision]) -> [ProvisionDisplayProvider] {
        var provsDisplayProvider = [ProvisionDisplayProvider]()
        for prov in provisions {
            let provProvider = ProvisionDisplayProvider(forProvision: prov)
            provsDisplayProvider.append(provProvider)
        }
        return provsDisplayProvider
    }
}



//===========================================================
// MARK: User provisions
//===========================================================



extension ProvisionGenericMethods {
    
    static func getUserProvisionsDisplayProvider() -> [ProvisionDisplayProvider] {
        var provsDisplayProvider = [ProvisionDisplayProvider]()
        for prov in UserProvisionsManager.shared.userProvisions {
            let provProvider = ProvisionDisplayProvider(forProvision: prov)
            provsDisplayProvider.append(provProvider)
        }
        return provsDisplayProvider
    }
    
    static func addUserProvision(withProductDP productDP: ProductDisplayProvider) {
        // on crée une nouvelle provision
        let newProvProvider = ProvisionDisplayProvider(forProvision: Provision(product: productDP.getProduct, isFood: true))
        
        UserProvisionsManager.shared.saveNewUserProvision(provision: newProvProvider.provOfDisplayProvider)
        NotificationCenter.default.post(name: .userProvisionsAdded, object: newProvProvider)
        
        print("\nUser provision \"" + newProvProvider.name + "\" added")
        print("(UUID: " + newProvProvider.uuidToString)
        print("Purchase date: \(newProvProvider.provOfDisplayProvider.purchaseDate)\n")
    }
    
    static func deleteUserProvision(ofProvDisplayProvider provProvider: ProvisionDisplayProvider) {
        UserProvisionsManager.shared.deleteUserProvision(provision: provProvider.provOfDisplayProvider)
        NotificationCenter.default.post(name: .userProvisionsDeleted, object: provProvider)
        
        print("\nUser provision \"" + provProvider.name + "\" deleted")
        print("(UUID: " + provProvider.uuidToString)
        print("Purchase date: \(provProvider.provOfDisplayProvider.purchaseDate)\n")
    }
    
    static func updateUserProvision(atIndexPath indexpath: IndexPath) {
        UserProvisionsManager.shared.updateUserProvisions()
        NotificationCenter.default.post(name: .userProvisionUpdated, object: indexpath)
        
        print("\nUser provisions updated\n")
    }
}
