//
//  DataStoreManagerTests.swift
//  TasksTests
//
//  Created by Ankush on 30/07/23.
//

import XCTest
@testable import Tasks

final class DataStoreManagerTests: XCTestCase {
    
    var sut: DataStoreManager!
    var mockDataStore: MockDataStore!

    override func setUpWithError() throws {
        try super.setUpWithError()

        mockDataStore = MockDataStore()
        sut = DataStoreManager(context: mockDataStore.context)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockDataStore = nil
        try super.tearDownWithError()
    }

    func testFetchTasks() throws {
        try sut.createTasks(TaskModel(name: "Task 1", description: nil, dueDate: nil, isComplete: false))

        guard let taskEntity = try sut.fetchTasks().first else {
            XCTFail("Could not fetch task from store.")
            return
        }
        
        let tasks = try sut.fetchTasks()
        XCTAssertTrue(tasks.count == 1)
        XCTAssertEqual(taskEntity.name, "Task 1")


    }

    func testCreateTask() throws {
        try sut.createTasks(TaskModel(name: "Task 2", description: nil, dueDate: nil, isComplete: false))
                
        let tasks = try sut.fetchTasks()

        XCTAssertTrue(tasks.count == 1)
    }

    func testUpdateTask() throws {
        try sut.createTasks(TaskModel(name: "Task 2", description: nil, dueDate: nil, isComplete: false))
        
        guard let taskEntity = try sut.fetchTasks().first else {
            XCTFail("Could not fetch task from store.")
            return
        }

        let dueDate = Date()
        let newTaskModel = TaskModel(name: "Task 2", description: "des", dueDate: dueDate, isComplete: true)

        try sut.updateTask(taskEntity: taskEntity, newTaskModel: newTaskModel)

        guard let updatedTaskEntity = try sut.fetchTasks().first else {
            XCTFail("Could not fetch task from store.")
            return
        }

        XCTAssert(updatedTaskEntity.name == "Task 2")
        XCTAssert(updatedTaskEntity.taskDescription == "des")
        XCTAssert(updatedTaskEntity.dueDate == dueDate)
        XCTAssert(updatedTaskEntity.isComplete == true)
    }
    
    func testDeleteTask() throws {
        try sut.createTasks(TaskModel(name: "Task 2", description: nil, dueDate: nil, isComplete: false))
        
        let tasks = try sut.fetchTasks()
        XCTAssert(tasks.count == 1, "Could not create task")

        guard let taskEntity = try sut.fetchTasks().first else {
            XCTFail("Could not fetch task from store.")
            return
        }

        try sut.deleteTask(taskEntity)
        
        let savedTasks = try sut.fetchTasks()

        XCTAssert(savedTasks.isEmpty, "Could not create task")
    }

}
