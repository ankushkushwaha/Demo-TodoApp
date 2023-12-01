//
//  EditTaskViewModelTests.swift
//  TasksTests
//
//  Created by Ankush on 30/07/23.
//

import XCTest
@testable import Tasks

final class EditTaskViewModelTests: XCTestCase {

    var dataStoreManager: DataStoreManager!
    var mockDataStore: MockDataStore!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockDataStore = MockDataStore()
        dataStoreManager = DataStoreManager(context: mockDataStore.context)
    }

    override func tearDownWithError() throws {
        dataStoreManager = nil
        mockDataStore = nil

        try super.tearDownWithError()
    }

    func testAddTask() throws {
        
        let sut = EditTaskViewModel(dataStore: dataStoreManager)

        sut.addTask(name: "Complete Assignment", description: nil, date: Date())
        
        let tasks = try dataStoreManager.fetchTasks()
        XCTAssertTrue(tasks.count == 1)
    }
    
    func testUpdateTask() throws {
        
        // Create Task
        let viewModel = EditTaskViewModel(dataStore: dataStoreManager)

        viewModel.addTask(name: "Complete Assignment", description: nil, date: nil, isComplete: false)

        guard let taskToEdit = try dataStoreManager.fetchTasks().first else {
            XCTFail("Task could not be created")
            return
        }
        XCTAssert(taskToEdit.name == "Complete Assignment")
        XCTAssertNil(taskToEdit.taskDescription)
        XCTAssertNil(taskToEdit.dueDate)
        XCTAssertFalse(taskToEdit.isComplete)

        
        // Update Task
        let sut = EditTaskViewModel(dataStore: dataStoreManager, taskToEdit: taskToEdit)

        let dueDate = Date()

        sut.updateTask(name: "Send Email", description: "Send email to client", dueDate: dueDate, isComplete: true)
        
        
        guard let updatedTask = try dataStoreManager.fetchTasks().first else {
            XCTFail("Task could not be created")
            return
        }

        XCTAssertEqual(updatedTask.name, "Send Email")
        XCTAssertEqual(updatedTask.taskDescription, "Send email to client")
        XCTAssertEqual(updatedTask.dueDate, dueDate)
        XCTAssertTrue(updatedTask.isComplete)
    }
    
    func testTaskCreatedStatus() {
        let sut = EditTaskViewModel(dataStore: dataStoreManager)

        sut.addTask(name: "Task", description: "Description", date: Date())
        XCTAssert(sut.status == .taskCreated)
    }
    
    func testTaskUpdatedStatus() throws {
        
        // Create Task
        let viewModel = EditTaskViewModel(dataStore: dataStoreManager)

        viewModel.addTask(name: "Complete Assignment", description: nil, date: nil, isComplete: false)

        guard let taskToEdit = try dataStoreManager.fetchTasks().first else {
            XCTFail("Task could not be created")
            return
        }
        
        XCTAssert(taskToEdit.name == "Complete Assignment")
        XCTAssertNil(taskToEdit.taskDescription)
        XCTAssertNil(taskToEdit.dueDate)
        XCTAssertFalse(taskToEdit.isComplete)
        
        // Update Task
        let sut = EditTaskViewModel(dataStore: dataStoreManager, taskToEdit: taskToEdit)

        let dueDate = Date()

        sut.updateTask(name: "Send Email", description: "Send email to client", dueDate: dueDate, isComplete: true)
        
        XCTAssert(sut.status == .taskUpdated)
    }
    
    func testEmptyNameErrorStatus() {
        let sut = EditTaskViewModel(dataStore: dataStoreManager)

        sut.addTask(name: "", description: "Description", date: Date())
        XCTAssert(sut.status == .validationError)
    }

}
