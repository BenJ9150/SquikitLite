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
// MARK: Add new provision
//===========================================================



extension ProvisionGenericMethods {
    
    static func addNewProvision(fromProduct product: Product, withState state: ProvisionState) -> Bool {
        // si on ajoute au shop ou au panier, on vérifie dans les 2 status
        if (state == .inShop || state == .inCart) && checkIfProductAlreadyAdded(fromId: product.Id, withState: .inShopOrCart) {
            return false
        }
        // on vérifie si la provision n'existe pas avec le même status
        if checkIfProductAlreadyAdded(fromId: product.Id, withState: state) {
            return false
        }
        // on crée une nouvelle provision
        guard let newProv = addNewProvisionToCoreData(fromProduct: product, withState: state) else {return false}
        // on crée un nouveau display provider
        let newProvProvider = ProvisionDisplayProvider(forProvision: newProv)
        
        switch state {
        case .inStock:
            NotificationCenter.default.post(name: .userProvisionsAdded, object: newProvProvider)
        case .inShop:
            NotificationCenter.default.post(name: .provAddedToShop, object: newProvProvider)
        case .inCart:
            NotificationCenter.default.post(name: .provAddedToCart, object: newProvProvider)
        case .inShopOrCart:
            return false
        }
        return true
    }
    
    private static func addNewProvisionToCoreData(fromProduct product: Product, withState state: ProvisionState) -> Provision? {
        let userProv = Provision(context: CoreDataStack.shared.viewContext)
        // is food ?
        let isFood = !AppSettings.noFoodsRef.contains { $0 == product.CategoryRef }
        // add values
        userProv.isFood = isFood
        userProv.productId = product.Id
        userProv.purchaseDate = Date()
        userProv.quantity = product.DefaultQuantity
        userProv.uuid = UUID.init()
        userProv.state = state.rawValue
        
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



extension ProvisionGenericMethods {
    
    static func deleteProvision(fromUUID uuid: UUID) {
        let provisionTab = Provision.getProvision(fromUUID: uuid)
        if provisionTab.count != 1 {return}
        // delete from coreData
        CoreDataStack.shared.viewContext.delete(provisionTab[0])
        do {
            try CoreDataStack.shared.viewContext.save()
        } catch let error {
            print(error)
        }
    }
}



//===========================================================
// MARK: update provisions
//===========================================================



extension ProvisionGenericMethods {
    
    static func saveProvisions() {
        // update in coreData
        do {
            try CoreDataStack.shared.viewContext.save()
        } catch let error {
            print(error)
        }
    }
}



//===========================================================
// MARK: Check provision in stock
//===========================================================



extension ProvisionGenericMethods {
    
    static func checkIfProductAlreadyAdded(fromId productId: String, withState state: ProvisionState) -> Bool {
        switch state {
        case .inStock:
            return Provision.allInStock.contains { $0.productId == productId }
        case .inShop:
            return Provision.allInShop.contains { $0.productId == productId }
        case .inCart:
            return Provision.allInCart.contains { $0.productId == productId }
        case .inShopOrCart:
            if Provision.allInShop.contains(where: { $0.productId == productId }) {
                return true
            }
            return Provision.allInCart.contains { $0.productId == productId }
        }
    
    }
}



//===========================================================
// MARK: Dico provisions display provider
//===========================================================



extension ProvisionGenericMethods {
    
    static func getUserProvisionsDisplayProvider(fromState state: ProvisionState, andUpadeCategories categories: inout [String]) -> [String: [ProvisionDisplayProvider]] {
        var provisionsDP = [String: [ProvisionDisplayProvider]]()
        
        switch state {
        case .inStock:
            for prov in Provision.allInStock {
                let _ = addItemToProvsDP(provDP: ProvisionDisplayProvider(forProvision: prov), toDico: &provisionsDP, andUpadeCategories: &categories)
            }
        case .inShop:
            for prov in Provision.allInShop {
                // on réinitialise la date d'achat à aujourd'hui
                prov.purchaseDate = Date()
                let _ = addItemToProvsDP(provDP: ProvisionDisplayProvider(forProvision: prov), toDico: &provisionsDP, andUpadeCategories: &categories)
            }
        case .inCart:
            for prov in Provision.allInCart {
                let _ = addItemToProvsDP(provDP: ProvisionDisplayProvider(forProvision: prov), toDico: &provisionsDP, andUpadeCategories: &categories)
            }
        case .inShopOrCart:
            for prov in Provision.allInShop {
                let _ = addItemToProvsDP(provDP: ProvisionDisplayProvider(forProvision: prov), toDico: &provisionsDP, andUpadeCategories: &categories)
            }
            for prov in Provision.allInCart {
                let _ = addItemToProvsDP(provDP: ProvisionDisplayProvider(forProvision: prov), toDico: &provisionsDP, andUpadeCategories: &categories)
            }
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
// MARK: DLC
//===========================================================



extension ProvisionGenericMethods {
    
    static func dlcToString(fromDLC dlc: Date?) -> String {
        guard let dlc = dlc else {
            return NSLocalizedString("dlcNoPeremptionMessage", comment: "")
        }
        
        // date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = AppSettings.dateFormat
        
        return NSLocalizedString("dlcSuffixString", comment: "") + " " + dateFormatter.string(from: dlc)
    }
}



//===========================================================
// MARK: Purchase date
//===========================================================



extension ProvisionGenericMethods {
    
    static func reinitPurchaseDate(forProvisionsDP provisionsDP: [String: [ProvisionDisplayProvider]]) {
        if provisionsDP.count <= 0 {return}
        if let firstProvsSection = provisionsDP.first, let firstProv = firstProvsSection.value.first {
            if let purchaseDate = firstProv.purchaseDate {
                if Calendar.current.compare(purchaseDate, to: Date(), toGranularity: .day) == .orderedSame {
                    return
                }
            }
        }
        // on réinitialise la date d'achat
        for (_, provsDP) in provisionsDP {
            for provDP in provsDP {
                provDP.purchaseDate = Date()
            }
        }
    }
}
