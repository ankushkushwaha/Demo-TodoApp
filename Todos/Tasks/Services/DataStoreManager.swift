//
//  DataStoreManager.swift
//  Tasks
//
//  Created by Ankush on 30/07/23.
//

import Foundation
import UIKit
import CoreData

class DataStoreManager {
    
    var context: NSManagedObjectContext?
    
    init(context: NSManagedObjectContext? = nil) { // dependancy injection for unit tests
        if let context = context {
            self.context = context
        } else if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            self.context = appDelegate.persistentContainer.viewContext
        }
    }
    
    func createTasks(_ taskItem: TaskModel) throws {
        
        guard let context = context else {
            return
        }
        let taskEntity = TaskEntity(context: context)
        taskEntity.id = UUID()
        taskEntity.name = taskItem.name
        taskEntity.taskDescription = taskItem.description ?? nil
        taskEntity.dueDate = taskItem.dueDate ?? nil
        taskEntity.isComplete = taskItem.isComplete ?? false

        try saveContext()
    }
    
    func fetchTasks() throws -> [TaskEntity] {
            let tasks = try context?.fetch(TaskEntity.fetchRequest())
            return tasks ?? []
    }
    
    func updateTask(taskEntity: TaskEntity, newTaskModel: TaskModel) throws {
        taskEntity.name = newTaskModel.name
        taskEntity.taskDescription = newTaskModel.description
        taskEntity.dueDate = newTaskModel.dueDate
        taskEntity.isComplete = newTaskModel.isComplete ?? false
        
        try saveContext()
    }
    
    func deleteTask(_ taskEntity: TaskEntity) throws {
        guard let context = context else {
            return
        }
        context.delete(taskEntity)
        try saveContext()
    }
    
    
    private func saveContext() throws {
        guard let context = context else {
            return
        }
        
        if context.hasChanges {
            try context.save()
        }
    }
}

