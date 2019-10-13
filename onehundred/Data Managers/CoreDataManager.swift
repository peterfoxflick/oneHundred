//
//  CoreDataManager.swift
//  onehundred
//
//  Created by Peter Flickinger on 9/10/19.
//  Copyright © 2019 Peter Flickinger. All rights reserved.
//

import Foundation
import CoreData
import SwiftUI

/************************
 The following naming convention is used for ease of use with the database
 
 Action
 C: Add
 R: Get
 U: Update
 D: Delete
 
 Name of function:
 Action - Object(s) - Qualifyer
 
 If the object is plural expect an array, otherwise a single object
 
 The Core data manager will only work with pure model classes, ie all ViewModels will not be used within this class. Instead the viewModel is responsible for converting an object/class to its own use.
 
 Functions should be classified by their return type, and orderd by their action.
 
 ************************/

class CoreDataManager {
    
   // static let shared = CoreDataManager(manageObjectContext: NSManagedObjectContext.current)
    
    
//    var managedObjectContext: NSManagedObjectContext
//
//    private init(manageObjectContext: NSManagedObjectContext){
//        self.managedObjectContext = manageObjectContext
//    }
//
    // New Stuff to try
//
    static let shared = CoreDataManager()

    lazy var persistentContainer: NSPersistentContainer! = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer
    }()
//
//    func setup(completion: (() -> Void)?) {
//        loadPersistentStore {
//            completion?()
//        }
//    }
//
//    // MARK: - Loading
//
//    private func loadPersistentStore(completion: @escaping () -> Void) {
//        //handle data migration on a different thread/queue here
//        persistentContainer.loadPersistentStores { description, error in
//            guard error == nil else {
//                fatalError("was unable to load store \(error!)")
//            }
//
//            completion()
//        }
//    }
//
//
    lazy var backgroundContext: NSManagedObjectContext = {
        let context = self.persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        return context
    }()
//
    lazy var managedObjectContext: NSManagedObjectContext = {
        let context = self.persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true

        return context
    }()

    
    
    
    
    ///
    
    // MARK: Tasks
    func addTask(title:String, createdAt: Date, dayID:UUID) {
        let task = Task(context: managedObjectContext)
        task.id = UUID()
        task.title = title
        task.createdAt = createdAt
        task.completedAt = createdAt
        
        let day = self.getDay(id: dayID)
        let tasks = day?.mutableSetValue(forKey: "tasks")
        tasks?.add(task)
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error)
        }
    }
    
    func getTasks() -> [Task] {
        var tasks = [Task]()
        
        let taskRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            tasks = try self.managedObjectContext.fetch(taskRequest)
        } catch {
            print(error)
        }
        
        return tasks
    }
    
    func getTasksFromDay(dayID:UUID) -> [Task] {
        let day = self.getDay(id: dayID)
        let tasks = day?.mutableSetValue(forKey: "tasks").allObjects
        if(tasks != nil){
            return tasks as! [Task]
        } else {
            return [Task]()
        }
    }
    
    private func getTask(id: UUID?) -> Task? {
        if(id == nil){
            return nil
        }
        
        var tasks = [Task]()
        
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", "id", id! as CVarArg)
        
        do {
            tasks = try self.managedObjectContext.fetch(request)
        } catch let error as NSError {
            print(error)
        }
        
        return tasks.first
    }
    
    func updateTask(id:UUID, title:String? = nil, createdAt:Date? = nil, completedAt:Date? = nil){
        let task = getTask(id: id)
        if(task == nil) {
            return
        }

        task?.title = title ?? task?.title
        task?.createdAt = createdAt ?? task?.createdAt
        task?.completedAt = completedAt ?? task?.completedAt
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error)
        }
        
    }
    
    func deleteTask(id: UUID) {
        do {
            if let task = getTask(id: id) {
                self.managedObjectContext.delete(task)
                try self.managedObjectContext.save()
            }
        } catch let error as NSError {
            print(error)
        }

    }
    
    // MARK: Prompts
    func addPrompt(text:String, fill:String) -> Prompt {
        let prompt = Prompt(context: managedObjectContext)
        prompt.id = UUID()
        prompt.text = text
        prompt.fill = fill
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error)
        }
        
        return prompt
    }
    
    private func getPrompt(id: UUID?) -> Prompt? {
        if(id == nil){
            return nil
        }
        
        var prompts = [Prompt]()
        
        let request: NSFetchRequest<Prompt> = Prompt.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", "id", id! as CVarArg)
        
        do {
            prompts = try self.managedObjectContext.fetch(request)
        } catch let error as NSError {
            print(error)
        }
        
        return prompts.first
    }
    
    func updatePrompt(id: UUID, text: String? = nil, fill:String? = nil){
        let prompt = getPrompt(id: id)
        if(prompt == nil) {
            return
        }
        prompt?.text = text ?? prompt?.text
        prompt?.fill = fill ?? prompt?.fill
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error)
        }
    }
    
    func deletePrompt(id: UUID) {
        do {
            if let prompt = getPrompt(id: id) {
                self.managedObjectContext.delete(prompt)
                try self.managedObjectContext.save()
            }
        } catch let error as NSError {
            print(error)
        }
    }
        
    // MARK: Response
    private func addResponse(answer:String, prompt:Prompt, order:Int) -> Response {
        let response = Response(context: managedObjectContext)
        response.id = UUID()
        response.answer = answer
        response.prompt = prompt
        response.order = Int16(order)
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error)
        }
        
        return response
    }
    
    func addNewResponseToParent(promptID:UUID, parentID:UUID, order:Int, parentType:ResponseParentType){
        
        let prompt = getPrompt(id:promptID)
        let response = addResponse(answer: "", prompt: prompt!, order:order)
        
        switch parentType {
        case .Goal:
            let goal = getGoal(id: parentID)
            response.goal = goal
            break
        case .Day:
            let day = getDay(id: parentID)
            response.day = day
        }
            
            
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error)
        }
        
    }
    
    private func getResponse(id:UUID) -> Response? {
        var responses = [Response]()
        
        let request: NSFetchRequest<Response> = Response.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", "id", id as CVarArg)
        
        do {
            responses = try self.managedObjectContext.fetch(request)
        } catch let error as NSError {
            print(error)
        }
        
        return responses.first
    }
    
    func getResponsesFromParent(parentType: ResponseParentType, parentID:UUID) -> [Response] {
        var responses = [Response]()
        
        switch parentType {
        case .Goal:
            let goal = getGoal(id: parentID)
            let temp = goal?.mutableSetValue(forKey: "responses").allObjects
            if(temp == nil) {
                responses = [Response]()
            } else {
                responses =  temp as! [Response]
            }
            break
        case .Day:
            let day = getDay(id: parentID)
            let temp = day?.mutableSetValue(forKey: "responses").allObjects
            if(temp == nil) {
                responses = [Response]()
            } else {
                responses =  temp as! [Response]
            }
        }
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error)
        }

            
        return responses
    }
    
    func getResponseParentType(type: ResponseParentType) -> AnyClass{
        switch type {
        case .Goal:
            return Goal.self
        case .Day:
            return Day.self
        }
    }
    
    func updateResponse(id:UUID, answer:String) {
        let response = getResponse(id: id)
        response?.answer = answer
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error)
        }
    }
    
    func deleteResponse(id: UUID) {
        do {
            if let response = getResponse(id: id) {
                self.managedObjectContext.delete(response)
                try self.managedObjectContext.save()
            }
        } catch let error as NSError {
            print(error)
        }
    }


        
    // MARK: Day
    
    func addDay(count:Int) -> Day? {
        let day = Day(context: managedObjectContext)
        day.count = Int16(count)
        day.id = UUID()
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error)
        }
        
        return day
    }
    
    func addDay(goalID:UUID) -> Day? {
        let day = Day(context: managedObjectContext)
        let goal = getGoal(id: goalID)
        let days = goal?.mutableSetValue(forKey: "days")
        
        //Values of day
        let id = UUID()
        day.id = id
        day.count = Int16(days?.count ?? 1)
        day.isCheckpoint = day.count - 1 % (goal?.checkpointLength ?? 10) == 0
        
        // Add to goal
        days?.add(day)
        
        // Add responses
        let dayPromptIDs = user.dayPrompts
        for (index, promptID) in dayPromptIDs.enumerated() {
            CoreDataManager.shared.addNewResponseToParent(promptID: promptID, parentID: id, order: index, parentType: ResponseParentType.Day )
        }
        
        if(day.isCheckpoint){
            let checkpointPromptIDs = user.checkpointPrompts
            let offset = dayPromptIDs.count
            for (index, promptID) in checkpointPromptIDs.enumerated() {
                CoreDataManager.shared.addNewResponseToParent(promptID: promptID, parentID: id, order: index + offset, parentType: ResponseParentType.Day )
            }
        }
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error)
        }
        
        return day
    }
        
    func getFirstDay() -> Day? {
        var days = [Day]()
        
        let dayRequest: NSFetchRequest<Day> = Day.fetchRequest()
        
        do {
            days = try self.managedObjectContext.fetch(dayRequest)
        } catch {
            print(error)
        }
        
        return days.first
    }
    
    func getDay(id: UUID) -> Day? {
        var days = [Day]()
        
        let request: NSFetchRequest<Day> = Day.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", "id", id as CVarArg)
        
        do {
            days = try self.managedObjectContext.fetch(request)
        } catch let error as NSError {
            print(error)
        }
        
        return days.first
    }
    
    private func deleteDay(id: UUID) {
        do {
            if let day = getDay(id: id) {
                self.managedObjectContext.delete(day)
                try self.managedObjectContext.save()
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    // MARK: Goal
    
    func addGoal(text:String, durration: Int, checkpointLength: Int) -> Goal? {
        let goal = Goal(context: managedObjectContext)
        goal.id = UUID()
        goal.text = text
        goal.durration = Int16(durration)
        goal.checkpointLength = Int16(checkpointLength)
        
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error)
        }
        
        return goal
    }
        
    func getFirstGoal() -> Goal? {
        var goals = [Goal]()
        
        let goalRequest: NSFetchRequest<Goal> = Goal.fetchRequest()
        
        do {
            goals = try self.managedObjectContext.fetch(goalRequest)
        } catch {
            print(error)
        }
                
        return goals.first
    }
    
    func getAllGoals() -> [Goal] {
        var goals = [Goal]()
        
        let goalRequest: NSFetchRequest<Goal> = Goal.fetchRequest()
        
        do {
            goals = try self.managedObjectContext.fetch(goalRequest)
        } catch {
            print(error)
        }
                
        return goals
    }
    
    func getGoal(id: UUID) -> Goal? {
        var goals = [Goal]()
        
        let request: NSFetchRequest<Goal> = Goal.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", "id", id as CVarArg)
        
        do {
            goals = try self.managedObjectContext.fetch(request)
        } catch let error as NSError {
            print(error)
        }
        
        return goals.first
    }
    
    func editGoal(id:UUID, text:String, durration: Int, checkpointLength: Int) -> Goal? {
        let goal = getGoal(id: id)
        goal?.text = text
        goal?.durration = Int16(durration)
        goal?.checkpointLength = Int16(checkpointLength)
        
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error)
        }
        
        return goal
    }

    

}
