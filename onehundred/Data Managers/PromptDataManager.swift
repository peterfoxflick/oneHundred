//
//  PromptDataManager.swift
//  onehundred
//
//  Created by Peter Flickinger on 10/7/19.
//  Copyright © 2019 Peter Flickinger. All rights reserved.
//

import Foundation
import CoreData

class PromptDataManager {
    let managedObjectContext: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataManager.shared.backgroundContext) {
        self.managedObjectContext = context
    }
    
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
    
    func getPrompt(id: UUID?) -> Prompt? {
        if(id == nil){
            return nil
        }
        
        var prompts = [Prompt]()
        
        let request: NSFetchRequest<Prompt> = Prompt.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", "id", id! as CVarArg)
        request.fetchLimit = 1
        
        do {
            prompts = try self.managedObjectContext.fetch(request)
        } catch let error as NSError {
            print(error)
        }
        
        return prompts.first
    }
    
    func getAllPrompts() -> [Prompt] {
        var prompts = [Prompt]()
        
        let request: NSFetchRequest<Prompt> = Prompt.fetchRequest()
        
        do {
            prompts = try self.managedObjectContext.fetch(request)
        } catch let error as NSError {
            print(error)
        }
        
        return prompts
    }
    
    func updatePrompt(id: UUID, text: String? = nil, fill:String? = nil) -> Prompt? {
        let prompt = getPrompt(id: id)
        if(prompt == nil) {
            return nil
        }
        prompt?.text = text ?? prompt?.text
        prompt?.fill = fill ?? prompt?.fill
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error)
        }
        
        return prompt
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

}

