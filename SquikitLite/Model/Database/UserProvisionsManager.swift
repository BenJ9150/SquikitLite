//
//  UserProvisionsManager.swift
//  SquikitLite
//
//  Created by Benjamin on 29/06/2023.
//

import Foundation



//===========================================================
// MARK: ProductManager class
//===========================================================



class UserProvisionsManager {
    
    // MARK: Private properties
    
    private let USER_PROVISIONS_BACKUP = "userProvisionsBackup"
    private var provisions: [Provision] = []
    private var provisionsLoaded = false
    
    // MARK: Public properties
    
    var userProvisions: [Provision] {
        // vérif tableau chargé
        if !provisionsLoaded {
            loadUserProvisions()
        }
        return provisions
    }
    
    // MARK: Singleton
    
    static let shared = UserProvisionsManager()
    private init() {}
}



//===========================================================
// MARK: Add new score
//===========================================================



extension UserProvisionsManager {
    
    func saveNewUserProvision(provision: Provision) {
        // vérif tableau chargé
        if !provisionsLoaded {
            loadUserProvisions()
        }
        // add and save
        provisions.append(provision)
        saveUserProvisionsToUserDefaults()
    }
}



//===========================================================
// MARK: delete provisions
//===========================================================



extension UserProvisionsManager {
    
    func deleteUserProvision(provision: Provision) {
        // vérif tableau chargé
        if !provisionsLoaded {
            loadUserProvisions()
        }
        provisions.removeAll { $0.uuid == provision.uuid }
        saveUserProvisionsToUserDefaults()
    }
}



//===========================================================
// MARK: update provisions
//===========================================================



extension UserProvisionsManager {
    
    func updateUserProvisions() {
        saveUserProvisionsToUserDefaults()
    }
}



//===========================================================
// MARK: Load or save scoreboard
//===========================================================



extension UserProvisionsManager {
    
    private func loadUserProvisions() {
        // récupère SVG
        if let encodedProvisions = UserDefaults.standard.object(forKey: USER_PROVISIONS_BACKUP) as? Data {
            // on décode la sauvegarde
            do {
                provisions = try JSONDecoder().decode([Provision].self, from: encodedProvisions)
                
            } catch let error {
                print(error)
            }
        }
        provisionsLoaded = true // à la fin pour indiquer qu'on a chargé même si 1ere utilisation donc pas de sauvegarde existante
    }
    
    private func saveUserProvisionsToUserDefaults() {
        // vérif tableau chargé
        if !provisionsLoaded {
            loadUserProvisions()
        }
        
        // encoder en JSON
        do {
            let encodedProvisions = try JSONEncoder().encode(provisions)
            // on sauvegarde
            UserDefaults.standard.set(encodedProvisions, forKey: USER_PROVISIONS_BACKUP)
            
        } catch let error {
            print(error)
        }
    }
}

