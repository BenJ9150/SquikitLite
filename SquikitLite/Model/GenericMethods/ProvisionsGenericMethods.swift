//
//  ProvisionsGenericMethods.swift
//  SquikitLite
//
//  Created by Benjamin on 28/06/2023.
//

import Foundation



//===========================================================
// MARK: ProvisionsGenericMethods class
//===========================================================



class ProvisionsGenericMethods {
    
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
// MARK: Database provisions
//===========================================================



extension ProvisionsGenericMethods {
    
    static func getDataBaseProvisionsDisplayProvider() -> [ProvisionDisplayProvider] {
        var provsDisplayProvider = [ProvisionDisplayProvider]()
        for prov in DatabaseProvisionsManager.shared.dataBaseProvisions {
            let provProvider = ProvisionDisplayProvider(forProvision: prov)
            provsDisplayProvider.append(provProvider)
        }
        return provsDisplayProvider
    }
}



//===========================================================
// MARK: User provisions
//===========================================================



extension ProvisionsGenericMethods {
    
    static func getUserProvisionsDisplayProvider() -> [ProvisionDisplayProvider] {
        var provsDisplayProvider = [ProvisionDisplayProvider]()
        for prov in UserProvisionsManager.shared.userProvisions {
            let provProvider = ProvisionDisplayProvider(forProvision: prov)
            provsDisplayProvider.append(provProvider)
        }
        return provsDisplayProvider
    }
    
    static func addUserProvision(ofProvDisplayProvider provProvider: ProvisionDisplayProvider) {
        UserProvisionsManager.shared.saveNewUserProvision(provision: provProvider.provisionOfDP)
        NotificationCenter.default.post(name: .userProvisionsAdded, object: provProvider)
    }
    
    static func deleteUserProvision(ofProvDisplayProvider provProvider: ProvisionDisplayProvider) {
        UserProvisionsManager.shared.deleteUserProvision(provision: provProvider.provisionOfDP)
        NotificationCenter.default.post(name: .userProvisionsDeleted, object: provProvider)
    }
}



//===========================================================
// MARK: Filters
//===========================================================



extension ProvisionsGenericMethods {
    
    static func filterProvisionsByName(fromProvsProvider provsProvider: [ProvisionDisplayProvider], withText searchText: String) -> [ProvisionDisplayProvider] {
        
        if searchText == "" {
            return provsProvider
        }
        
        var searchedProvsProvider = provsProvider.filter({ provProvider in
            // name
            if provProvider.name.cleanUpForComparaison.prefix(searchText.count) == searchText.cleanUpForComparaison {
                return true
            }
            // subCat
            if provProvider.subCategory.cleanUpForComparaison.prefix(searchText.count) == searchText.cleanUpForComparaison {
                return true
            }
            // variants
            for variant in provProvider.variants {
                if String(variant).cleanUpForComparaison.prefix(searchText.count) == searchText.cleanUpForComparaison {
                    return true
                }
            }
            // cat
            if provProvider.category.cleanUpForComparaison.prefix(searchText.count) == searchText.cleanUpForComparaison {
                return true
            }
            return false
        })
        
        searchedProvsProvider.sort { $0.name.count < $1.name.count }
        
        return searchedProvsProvider
    }
}
