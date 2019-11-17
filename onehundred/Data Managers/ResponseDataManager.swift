//
//  ResponseDataManager.swift
//  onehundred
//
//  Created by Peter Flickinger on 10/18/19.
//  Copyright © 2019 Peter Flickinger. All rights reserved.
//

import Foundation
import CoreData

class ResponseDataManager {
    let managedObjectContext: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataManager.shared.backgroundContext) {
        self.managedObjectContext = context
    }
    
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
        
        let prompt = PromptDataManager(context: self.managedObjectContext).getPrompt(id: promptID)
        let response = addResponse(answer: "", prompt: prompt!, order:order)
        
        switch parentType {
        case .Goal:
            let goal = GoalDataManager(context: self.managedObjectContext).getGoal(id: parentID)
            response.goal = goal
            break
        case .Day:
            let day = DayDataManager(context: self.managedObjectContext).getDay(id: parentID)
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
            let goal = GoalDataManager(context: self.managedObjectContext).getGoal(id: parentID)
            let temp = goal?.mutableSetValue(forKey: "responses").allObjects
            if(temp == nil) {
                responses = [Response]()
            } else {
                responses =  temp as! [Response]
            }
            break
        case .Day:
            let day = DayDataManager(context: self.managedObjectContext).getDay(id: parentID)
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

}
