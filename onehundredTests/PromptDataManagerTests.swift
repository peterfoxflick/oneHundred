//
//  PromptDataManagerTests.swift
//  onehundredTests
//
//  Created by Peter Flickinger on 10/7/19.
//  Copyright © 2019 Peter Flickinger. All rights reserved.
//

import XCTest
import CoreData
@testable import onehundred


class PromptDataManagerTests: XCTestCase {
    
    var sut: PromptDataManager!
    
    var coreDataStack: CoreDataTestStack!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        coreDataStack = CoreDataTestStack()
        
        sut = PromptDataManager(context: coreDataStack.backgroundContext)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_add_prompt() {
        let text = "What are you greatfull for today?"
        let fill = "I love the sun..."
        
        let prompt = sut.addPrompt(text: text, fill: fill)
        
        XCTAssertEqual(prompt.text, text, "PDM - Failed to save prompt text")
        XCTAssertEqual(prompt.fill, fill, "PDM - Failed to save prompt fill")
    }
    
    func test_get_prompt(){
        let prompt = sut.addPrompt(text: "How will you be acoutable to your goal?", fill: "I will check in every day")
        
        let id = prompt.id
        
        let fetchedPrompt = sut.getPrompt(id: id)
        
        XCTAssertEqual(prompt, fetchedPrompt, "PDM - Failed to get prompt from db")

    }
    
    func test_update_prompt(){
        let prompt = sut.addPrompt(text: "What will you do today?", fill: "I will acomplish...")
        
        let newText = "What is your main focus today?"
        let newFill = "I will focus on..."
        
        let updatedPrompt = sut.updatePrompt(id: prompt.id!, text: newText, fill: newFill)
        
        XCTAssertEqual(updatedPrompt!.text, newText, "PDM - Failed to update prompt text")
        XCTAssertEqual(updatedPrompt!.fill, newFill, "PDM - Failed to update prompt text")
    }
    
    func test_delete_prompt(){
        let request: NSFetchRequest<Prompt> = Prompt.fetchRequest()
        do {
            let startCount = try sut.managedObjectContext.fetch(request).count
            
            let prompt = sut.addPrompt(text: "hi", fill: "Fill")
            
            let midCount = try sut.managedObjectContext.fetch(request).count
            
            sut.deletePrompt(id: prompt.id!)
            
            let endCount = try sut.managedObjectContext.fetch(request).count
            
            
            XCTAssertEqual(startCount, endCount, "PDM - Failed in deleting a prompt")
            XCTAssertEqual(startCount, midCount - 1, "PDM - Failed in adding a prompt")

        } catch let error as NSError {
            print(error)
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
