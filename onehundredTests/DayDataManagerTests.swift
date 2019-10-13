//
//  DayDataManagerTests.swift
//  onehundredTests
//
//  Created by Peter Flickinger on 10/2/19.
//  Copyright © 2019 Peter Flickinger. All rights reserved.
//

import XCTest
@testable import onehundred


class DayDataManagerTests: XCTestCase {
    var sut: DayDataManager!
    
    var coreDataStack: CoreDataTestStack!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        coreDataStack = CoreDataTestStack()
        sut = DayDataManager(context: coreDataStack.backgroundContext)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: - Tests
    
    func test_add_day_count() {
        let day = sut.addDay(count: 1)
        XCTAssertEqual(day!.count, 1, "DayDM - Failed to save count")
    }
    
    func test_add_day_to_goal(){
        let goalDM = GoalDataManager(context: coreDataStack.backgroundContext)
        let checkpoint = 10
        let goal = goalDM.addGoal(text: "Code", durration: 100, checkpointLength: checkpoint)
        
        let day = sut.addDay(goalID: goal!.id!)
        
        let goalDay = goal?.days?.allObjects.first as! Day
        
        XCTAssertEqual(day, goalDay, "DayDM - Failed to add day to goal")
        
        //Now test counting
        XCTAssertEqual(day!.count, 1, "DayDM - Failed to add first day with proper count 1")

        let secondDay = sut.addDay(goalID: goal!.id!)
        XCTAssertEqual(secondDay!.count, 2, "DayDM - Failed to add second day with proper count 2")
        
        let thirdDay = sut.addDay(goalID: goal!.id!)
        XCTAssertEqual(thirdDay!.count, 3, "DayDM - Failed to add third day with proper count 3")
        
        XCTAssertEqual(goal?.days?.count, 3, "DayDM - Failed to add days to goal")

        //Now add a few days
        for _ in 1...80 {
            let _ = sut.addDay(goalID: goal!.id!)
        }
        
        //Now test checkpoint logic
        XCTAssertEqual(day!.isCheckpoint, true, "DayDM - Failed to add first day as checkpoint")
        XCTAssertEqual(secondDay!.isCheckpoint, false, "DayDM - Failed to add second day as non-checkpoint")
        
        let days = goal!.days!.sorted(by: {($0 as! Day).count < ($1 as! Day).count})
        
        //Manual check just to ensure logic
        XCTAssertEqual((days[checkpoint] as! Day).isCheckpoint, true, "DayDM - Failed to add second checkpoint")
        XCTAssertEqual((days[checkpoint * 2] as! Day).isCheckpoint, true, "DayDM - Failed to add third checkpoint")

        
        //Now check all of them
        for (index, day) in days.enumerated() {
            let d = day as! Day
            XCTAssertEqual(d.count, Int16(index + 1), "DayDM - Failed to add day \(index) with proper cound. Used \(d.count) instead")
            XCTAssertEqual(d.isCheckpoint, (d.count - 1) % Int16(checkpoint) == 0, "DayDM - Failed to add day \(index) with proper checkpoint flag")
        }
        
    }
        
    func getFirstDay() {
       
    }
    
    func getDay(id: UUID) {
    }
    
    func deleteDay(id: UUID) {
    }
        
    func test_init_contexts() {
        XCTAssertEqual(sut.managedObjectContext, coreDataStack.backgroundContext)
    }
    

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
