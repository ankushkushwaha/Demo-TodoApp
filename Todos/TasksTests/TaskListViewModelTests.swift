//
//  TasksTests.swift
//  TasksTests
//
//  Created by Ankush on 30/07/23.
//

import XCTest
@testable import Tasks

final class TaskListViewModelTests: XCTestCase {

    var sut: TaskListViewModel!
    var dataStoreManager: DataStoreManager!
    var mockDataStore: MockDataStore!
    
    override func setUpWithError() throws {
        try super.setUpWithError()

        mockDataStore = MockDataStore()
        dataStoreManager = DataStoreManager(context: mockDataStore.context)
        sut = TaskListViewModel(dataStore: dataStoreManager)
    }

    override func tearDownWithError() throws {
        sut = nil
        dataStoreManager = nil
        mockDataStore = nil
        try super.tearDownWithError()
    }

    func testFetchItems() throws {
        
        try dataStoreManager.createTasks(TaskModel(name: "Task 1", description: nil, dueDate: nil, isComplete: false))
                
        XCTAssertTrue(sut.taskItems.count == 1)
    }
    
    func testDeleteItem() throws {
        
        try dataStoreManager.createTasks(TaskModel(name: "Task 1", description: nil, dueDate: nil, isComplete: false))

        sut.deleteTask(atindex: 0)
        XCTAssertTrue(sut.taskItems.isEmpty)
    }
    
    func testOperationStatusSuccess() throws {
        
        try dataStoreManager.createTasks(TaskModel(name: "Task 1", description: nil, dueDate: nil, isComplete: false))

        XCTAssertTrue(sut.status == .success)
    }
}

