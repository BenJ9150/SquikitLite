//
//  UserProvision.swift
//  SquikitLite
//
//  Created by Benjamin on 04/07/2023.
//

import Foundation
import CoreData



//===========================================================
// MARK: UserProvision class
//===========================================================



class UserProvision: NSManagedObject {
    
    static var all: [UserProvision] {
        let request: NSFetchRequest<UserProvision> = UserProvision.fetchRequest()
        
        
        guard let userProvisions = try? CoreDataStack.shared.viewContext.fetch(request) else {
            return []
        }
        return userProvisions
    }
    
    static func getUserProvision(fromUUID uuid: UUID) -> UserProvision? {
        let request: NSFetchRequest<UserProvision> = UserProvision.fetchRequest()
        request.fetchLimit = 1
        if let userProvision = try? CoreDataStack.shared.viewContext.fetch(request).first(where: { $0.uuid == uuid }) {
            return userProvision
        }
        return nil
    }
}
