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
    
    static func addUserProvision(withProductDP productDP: ProductDisplayProvider) {
        // on crée une nouvelle provision
        let isNoFood = AppSettings.noFoodsRef.contains { $0 == productDP.getProduct.CategoryRef }
        
        let newProvProvider = ProvisionDisplayProvider(forProvision: Provision(product: productDP.getProduct, isFood: !isNoFood))
        
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



//===========================================================
// MARK: display provider
//===========================================================



extension ProvisionGenericMethods {
    
    static func getUserProvisionsDisplayProviderOLD() -> [ProvisionDisplayProvider] { // A SUPPRIMER
        var provsDisplayProvider = [ProvisionDisplayProvider]()
        for prov in UserProvisionsManager.shared.userProvisions {
            let provProvider = ProvisionDisplayProvider(forProvision: prov)
            provsDisplayProvider.append(provProvider)
        }
        return provsDisplayProvider
    }
    
    static func getUserProvisionsDisplayProvider(andUpadeCategories categories: inout [String]) -> [String: [ProvisionDisplayProvider]] {
        var provisionsDP = [String: [ProvisionDisplayProvider]]()
        for prov in UserProvisionsManager.shared.userProvisions {
            let _ = addItemToProvsDisplayProvider(provDP: ProvisionDisplayProvider(forProvision: prov), toDico: &provisionsDP, andUpadeCategories: &categories)
        }
        return provisionsDP
    }
    
    static func addItemToProvsDisplayProvider(provDP: ProvisionDisplayProvider, toDico dico: inout [String: [ProvisionDisplayProvider]], andUpadeCategories categories: inout [String]) -> (index: IndexPath?, newSection: Bool) {
        // on recherche si une section existe déjà
        var newSection = false
        if !categories.contains(provDP.category) {
            // on ajoute une nouvelle section
            categories.append(provDP.category)
            dico[provDP.category] = [provDP]
            newSection = true
        } else {
            // la section existe déjà
            dico[provDP.category]?.append(provDP)
        }
        // on retourne l'indexPath (pour update IHM)
        guard let row = dico[provDP.category]?.firstIndex(where: { $0.uuid == provDP.uuid }) else {return (nil, false)}
        guard let section = categories.firstIndex(of: provDP.category) else {return (nil, false)}
        return (IndexPath(row: row, section: section), newSection)
    }
    
    static func deleteItemFromProvsDisplayProvider(provDP: ProvisionDisplayProvider, toDico dico: inout [String: [ProvisionDisplayProvider]], andUpadeCategories categories: inout [String]) -> (index: IndexPath?, deleteSection: Int?) {
        // on récupère l'indexPath de la provision à supprimer (pour update IHM)
        guard let row = dico[provDP.category]?.firstIndex(where: { $0.uuid == provDP.uuid }) else {return (nil, nil)}
        guard let section = categories.firstIndex(of: provDP.category) else {return (nil, nil)}
        // on retire la provision
        dico[provDP.category]?.remove(at: row)
        // on supprime la section si vide
        if let provsInSection = dico[provDP.category], provsInSection.isEmpty {
            dico.removeValue(forKey: provDP.category)
            categories.removeAll { $0 == provDP.category }
            return (IndexPath(row: row, section: section), section)
        }
        return (IndexPath(row: row, section: section), nil)
        
        /*
        guard let section = dico.first(where: { $1.first?.category == provDP.category })?.key  else {return (false, nil, nil)}
        if section >= dico.count {return (false, nil, nil)}
        guard let row = dico[section]?.firstIndex(where: { $0.uuid == provDP.uuid }) else {return (false, nil, nil)}
            
        // on retire la provision
        dico[section]?.remove(at: row)//?.removeAll { $0.uuid == provisionDP.uuid }
        // on supprime la section si vide
        if let count = dico[section]?.count, count <= 0 {
            dico.removeValue(forKey: section)
            return (true, IndexPath(row: row, section: section), section)
        }
        return (true, IndexPath(row: row, section: section), nil)
         */
    }
}



//===========================================================
// MARK: DLC formatter
//===========================================================



extension ProvisionGenericMethods {
    
    static func dlcToString(fromDLC dlc: Date?) -> String {
        guard let dlc = dlc else {
            return NSLocalizedString("dlcNoPeremptionMessage", comment: "")
        }
        
        // date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = AppSettings.dateFormat
        
        return NSLocalizedString("dlcSuffixString", comment: "") + dateFormatter.string(from: dlc)
    }
}
