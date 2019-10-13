//
//  taskTests.swift
//  onehundredTests
//
//  Created by Peter Flickinger on 9/16/19.
//  Copyright © 2019 Peter Flickinger. All rights reserved.
//

import XCTest
@testable import onehundred


class TaskDataManagerTests: XCTestCase {
    
    var sut: TaskDataManager!
    
    var coreDataStack: CoreDataTestStack!
    
    var goal : Goal!
    var day : Day!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        coreDataStack = CoreDataTestStack()
        
        sut = TaskDataManager(context: coreDataStack.backgroundContext)
        
        goal = GoalDataManager(context: coreDataStack.backgroundContext).addGoal(text: "Code", durration: 100, checkpointLength: 10)
        
        day = DayDataManager(context: coreDataStack.backgroundContext).addDay(goalID: goal.id!)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        GoalDataManager(context: coreDataStack.backgroundContext).deleteGoal(id: self.goal.id!)
    }
    
    // MARK: - Tests
    
    // MARK: Init
    
    func test_init_contexts() {
        XCTAssertEqual(sut.managedObjectContext, coreDataStack.backgroundContext, "Error in context")
    }
    
    func test_add_task(){
        let title = "My new task"
        let createdAt = Date()
        
        let task = sut.addTask(title: title, createdAt: createdAt, dayID: day.id!)
        
        XCTAssertEqual(task.title, title , "TaskDM - Failed to create task with title")
        XCTAssertEqual(task.createdAt, createdAt , "TaskDM - Failed to create task with creeaeted date")
        XCTAssertEqual(task.completedAt, createdAt , "TaskDM - Failed to create task with complete date")
        XCTAssertEqual(task.day, day , "TaskDM - Failed to add task to day")
    }
    
    func test_get_tasks(){
        add_dummy_tasks()
        
        let tasks = sut.getTasksFromDay(dayID: day.id!)
        
        XCTAssert(tasks.count > 0, "TaskDM - Failed to fetch added tasks")
        
        //Test to ensure it isn't getting anouther days tasks
    }
    
    func test_update_task(){
        let task = sut.addTask(title: "Read a book", createdAt: Date(), dayID: day.id!)
        
        let title = "Go for a walk"
        let now = Date()
        
        let updatedTask = sut.updateTask(id: task.id!, title: title, createdAt: now, completedAt: now)
        
        XCTAssertEqual(updatedTask!.title, title , "TaskDM - Failed to update task with title")
        XCTAssertEqual(updatedTask!.createdAt, now , "TaskDM - Failed to update task with creeaeted date")
        XCTAssertEqual(updatedTask!.completedAt, now , "TaskDM - Failed to update task with complete date")
    }
    
    func test_delete_task(){
        add_dummy_tasks()
        
        let tasks = sut.getTasksFromDay(dayID: day.id!)
        let startCount = tasks.count
        
        for task in tasks{
            sut.deleteTask(id: task.id!)
        }
        
        let endCount = sut.getTasksFromDay(dayID: day.id!).count
        
        XCTAssert(startCount > 0 , "TaskDM - Failed to add tasks")
        XCTAssert(endCount == 0 , "TaskDM - Failed to delete tasks, \(endCount) remaining")
    }
    
    
    func add_dummy_tasks(){
        _ = sut.addTask(title: "Mow the lawn", createdAt: Date(), dayID: day.id!)
        _ = sut.addTask(title: "Get new shoes", createdAt: Date(), dayID: day.id!)
        _ = sut.addTask(title: "Go for a walk", createdAt: Date(), dayID: day.id!)
    }
}
