//
//  TaskListViewModel.swift
//  Tasks
//
//  Created by Ankush on 30/07/23.
//

import Foundation
import Combine
import CoreData

enum OperationStatus {
    case success
    case databaseFetchOperationError
    case databaseDeleteOperationError
}

class TaskListViewModel: ObservableObject {
    @Published var taskItems: [TaskEntity] = []
    @Published var status: OperationStatus = .success
    private let dataStore: DataStoreManager
    
    private var cancellables = Set<AnyCancellable>()

    init(dataStore: DataStoreManager = DataStoreManager()) { // dependancy injection
        self.dataStore = dataStore
               
        // Observer for managedObjectContext changes
        NotificationCenter.default.addObserver(self, selector: #selector(contextDidSave(_:)), name: Notification.Name.NSManagedObjectContextDidSave, object: nil)
    }

    @objc func contextDidSave(_ notification: Notification) {
        fetchTaskItems()
    }

    func taskAtIndex(_ index: Int) -> TaskEntity? {
        if !taskItems.indices.contains(index) {
            return nil
        }
        return taskItems[index]
    }
    
    func numberOfTasks() -> Int {
        taskItems.count
    }

}

extension TaskListViewModel {

    func fetchTaskItems() {
        do {
            taskItems = try dataStore.fetchTasks().reversed()
            status = .success
        } catch {
            status = .databaseFetchOperationError
        }
    }
    
    func deleteTask(atindex index: Int) {
        if !taskItems.indices.contains(index) {
            return
        }
        
        let taskEntity = taskItems[index]
        do {
            try dataStore.deleteTask(taskEntity)
        } catch {
            status = .databaseDeleteOperationError
        }
    }
}
