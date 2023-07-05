//
//  CoreDataStack.swift
//  SquikitLite
//
//  Created by Benjamin on 01/07/2023.
//

import Foundation
import UIKit
import CoreData



//===========================================================
// MARK: CoreDataStack class
//===========================================================



final class CoreDataStack {
    
    // MARK: Properties
    
    var viewContext: NSManagedObjectContext {
      return CoreDataStack.shared.persistentContainer.viewContext
    }
    
    // MARK: Private lazy

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: AppSettings.persistentContainerName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
          fatalError("Unresolved error \(error), \(error.userInfo)")
        }
      })
      return container
    }()
    
    // MARK: Singleton
    
    static let shared = CoreDataStack()
    private init() {}
}

