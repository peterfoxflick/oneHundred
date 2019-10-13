//
//  GoalDataManagerTests.swift
//  onehundredTests
//
//  Created by Peter Flickinger on 10/1/19.
//  Copyright © 2019 Peter Flickinger. All rights reserved.
//

import XCTest
@testable import onehundred

class GoalDataManagerTests: XCTestCase {
    
    var sut: GoalDataManager!
    
    var coreDataStack: CoreDataTestStack!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        coreDataStack = CoreDataTestStack()
        
        sut = GoalDataManager(context: coreDataStack.backgroundContext)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: - Tests
        
    func test_init_contexts() {
        XCTAssertEqual(sut.managedObjectContext, coreDataStack.backgroundContext)
    }
    
    func test_add_goal(){
        let text = "Code"
        let durration = 100
        let checkpoint = 7
        
        let goal = sut.addGoal(text: text, durration: durration, checkpointLength: checkpoint)
        
        XCTAssertEqual(goal?.text, text, "GoalDM - Failed to save text")
        XCTAssertEqual(goal?.durration, Int16(durration), "GoalDM - Failed to save durration")
        XCTAssertEqual(goal?.checkpointLength, Int16(checkpoint), "GoalDM - Failed to save checkpoint length")
    }
    
    func test_get_first_goal(){
        let firstGoal = sut.addGoal(text: "Code", durration: 100, checkpointLength: 7)

        add_100_goals()
        
        let fetchedGoal = sut.getFirstGoal()
        XCTAssertEqual(firstGoal, fetchedGoal, "GoalDM - Failed to retrieve the first goal")

    }
    
    func test_get_all_goals(){
        add_100_goals()
        
        let goals = sut.getAllGoals()
        
        XCTAssertEqual(goals.count, 100, "GoalDM - Failed to create for fetch all goals")
    }
    
    func test_get_goal(){
        let myGoal = sut.addGoal(text: "Code", durration: 100, checkpointLength: 7)
        
        let fetchedGoal = sut.getGoal(id: myGoal?.id ?? UUID())
        
        XCTAssertEqual(myGoal, fetchedGoal, "GoalDM - Failed to retrieve goal by id")
    }
    
    func test_edit_goal(){
        let goal = sut.addGoal(text: "Code", durration: 100, checkpointLength: 7)
        
        let text = "Meditation"
        let durration = 38
        let checkpoint = 10
        
        let edited = sut.editGoal(id: goal!.id!, text: text, durration: durration, checkpointLength: checkpoint)
                
        XCTAssertEqual(edited?.text, text, "GoalDM - Failed to edit text")
        XCTAssertEqual(edited?.durration, Int16(durration), "GoalDM - Failed to edit durration")
        XCTAssertEqual(edited?.checkpointLength, Int16(checkpoint), "GoalDM - Failed to edit checkpoint length")
        
    }
    
    func test_delete_goal(){
        let startCount = sut.getAllGoals().count
        let goal = sut.addGoal(text: "Code", durration: 100, checkpointLength: 7)
        let addedCount = sut.getAllGoals().count
        
        sut.deleteGoal(id: goal!.id!)
        
        let endCount = sut.getAllGoals().count
        
        XCTAssertEqual(startCount, addedCount - 1, "GoalDM - Failed to add goal")
        XCTAssertEqual(startCount, endCount, "GoalDM - Failed to delete goal")
    }
    
    
    func add_100_goals(){
        let titles = ["Code", "Meditation", "Health", "Scriptures", "Reading", "Fitness", "Routine"]
        let checkpoints = [5, 7, 10]
        
        for _ in 1...100 {
            let title = titles[Int.random(in: 0..<titles.count)]
            let durration = Int.random(in: 1..<200)
            let checkpoint = checkpoints[Int.random(in: 0..<checkpoints.count)]

            let _ = sut.addGoal(text: title, durration: durration, checkpointLength: checkpoint)
        }
        
    }
        
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

