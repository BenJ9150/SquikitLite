//
//  ProvisionGenericMethods.swift
//  SquikitLite
//
//  Created by Benjamin on 28/06/2023.
//

import Foundation



//===========================================================
// MARK: ProvisionGenericMethods class
//===========================================================



class ProvisionGenericMethods {
    
}



//===========================================================
// MARK: Dico provisions display provider
//===========================================================



extension ProvisionGenericMethods {
    
    static func getUserProvisionsDisplayProvider(andUpadeCategories categories: inout [String]) -> [String: [ProvisionDisplayProvider]] {
        var provisionsDP = [String: [ProvisionDisplayProvider]]()
        for prov in Provision.all {
            let _ = addItemToProvsDP(provDP: ProvisionDisplayProvider(forProvision: prov), toDico: &provisionsDP, andUpadeCategories: &categories)
        }
        return provisionsDP
    }
    
    static func addItemToProvsDP(provDP: ProvisionDisplayProvider, toDico dico: inout [String: [ProvisionDisplayProvider]], andUpadeCategories categories: inout [String]) -> (index: IndexPath?, newSection: Bool) {
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
    
    static func deleteItemFromDP(provDP: ProvisionDisplayProvider, toDico dico: inout [String: [ProvisionDisplayProvider]], andUpadeCategories categories: inout [String]) -> (index: IndexPath?, deleteSection: Int?) {
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
