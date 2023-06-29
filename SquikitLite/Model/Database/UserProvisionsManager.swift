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
        
        provisions.append(provision)
        
        saveUserProvisionsToUserDefaults()
    }
}



//===========================================================
// MARK: Load or save scoreboard
//===========================================================



extension UserProvisionsManager {
    
    private func loadUserProvisions() {
        // récupère SVG
        let optArchivedObj = UserDefaults.standard.data(forKey: USER_PROVISIONS_BACKUP)
        if let archivedObj = optArchivedObj {
            // on décode la sauvegarde
            do {
                let unarchivedObj = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, Provision.self], from: archivedObj) as! [Provision]
                // copie du tableau
                provisions = unarchivedObj
            } catch {}
        }
        
        provisionsLoaded = true // à la fin pour indiquer qu'on a chargé même si 1ere utilisation donc pas de sauvegarde existante
    }
    
    private func saveUserProvisionsToUserDefaults() {
        // vérif tableau chargé
        if !provisionsLoaded {
            loadUserProvisions()
        }
        
        do {
            let newArchivedObj = try NSKeyedArchiver.archivedData(withRootObject: provisions, requiringSecureCoding: true)
            // svg du tableau
            UserDefaults.standard.set(newArchivedObj, forKey: USER_PROVISIONS_BACKUP)
        } catch let error {
            print(error)
        }
    }
}

