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
        for prov in DataBaseProvisionsManager.shared.dataBaseProvisions {
            let provProvider = ProvisionDisplayProvider(forProvision: prov)
            provsDisplayProvider.append(provProvider)
        }
        return provsDisplayProvider
    }
    
    static func getDataBaseProvisionsCount() -> Int {
        return DataBaseProvisionsManager.shared.count
    }
}



//===========================================================
// MARK: User provisions
//===========================================================



extension ProvisionsGenericMethods {
    
    static func getUserProvisionsDisplayProvider() -> [ProvisionDisplayProvider] {
        // TO DO
        return getDataBaseProvisionsDisplayProvider()
    }
}
