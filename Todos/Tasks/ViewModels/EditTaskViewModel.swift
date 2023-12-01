//
//  EditTaskViewModel.swift
//  Tasks
//
//  Created by Ankush on 30/07/23.
//

import Foundation

enum Status {
    case taskCreated
    case taskUpdated
    case validationError
    case databaseOperationError
}

class EditTaskViewModel: ObservableObject {
    @Published var status: Status = .validationError
    
    private let dataStore: DataStoreManager
    var taskToEdit: TaskEntity?
    
    init(dataStore: DataStoreManager = DataStoreManager(),
         taskToEdit: TaskEntity? = nil) { // dependancy injection
        self.dataStore = dataStore
        self.taskToEdit = taskToEdit
    }
}

extension EditTaskViewModel {
    
    func updateTask(name: String?,
                    description: String?,
                    dueDate: Date?,
                    isComplete: Bool) {
        guard let name = name,
              name.count > 1 else {
            status = .validationError
            return
        }
        
        guard let taskToEdit = taskToEdit else {
            return
        }
        
        let newTaskModel = TaskModel(name: name, description: description, dueDate: dueDate, isComplete: isComplete)
        do {
            try dataStore.updateTask(taskEntity: taskToEdit, newTaskModel: newTaskModel)
            status = .taskUpdated

        } catch {
            status = .databaseOperationError
        }
    }
    
    func addTask(name: String?,
                 description: String?,
                 date: Date?,
                 isComplete: Bool = false) {
        guard let name = name, name.count > 1 else {
            status = .validationError
            return
        }
        
        let item = TaskModel(name: name, description: description, dueDate: date, isComplete: isComplete)
        do {
            try dataStore.createTasks(item)
            status = .taskCreated
        } catch {
            status = .databaseOperationError
        }
    }
}
