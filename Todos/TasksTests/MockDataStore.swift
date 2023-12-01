//
//  MockDataStore.swift
//  TasksTests
//
//  Created by Ankush on 30/07/23.
//

import Foundation
import CoreData

class MockDataStore {
    
    let coreDataName = "Tasks"
    var context: NSManagedObjectContext? {
        persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
       let container = NSPersistentContainer(name: coreDataName)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                 fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
        
}
