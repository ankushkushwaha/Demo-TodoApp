//
//  TaskCellViewModelTests.swift
//  TasksTests
//
//  Created by Ankush on 30/07/23.
//

import XCTest

@testable import Tasks

final class TaskCellViewModelTests: XCTestCase {

    var sut: TaskCellViewModel!
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

    func testIncompleteTaskCase() throws {
        
        let taskModel = TaskModel(name: "Task 1", description: nil, dueDate: nil, isComplete: false)
        
        try dataStoreManager.createTasks(taskModel)

        guard let taskEntity = try dataStoreManager.fetchTasks().first else {
            XCTFail("Could not fetch task from store.")
            return
        }
        
        let sut = TaskCellViewModel(task: taskEntity)
        
        XCTAssertTrue(sut?.backGroundColor == .clear)
        XCTAssertTrue(sut?.accessoryType == UITableViewCell.AccessoryType.none)
    }

    func testCompletedTaskCase() throws {
        
        let taskModel = TaskModel(name: "Task 1", description: nil, dueDate: nil, isComplete: true)
        
        try dataStoreManager.createTasks(taskModel)

        guard let taskEntity = try dataStoreManager.fetchTasks().first else {
            XCTFail("Could not fetch task from store.")
            return
        }
        
        let sut = TaskCellViewModel(task: taskEntity)
        
        XCTAssertTrue(sut?.backGroundColor == sut?.backgroundColorForCompletedTask)
        XCTAssertTrue(sut?.accessoryType == .checkmark)
    }
}
