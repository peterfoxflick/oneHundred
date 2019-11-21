//
//  GoalDataManager.swift
//  onehundred
//
//  Created by Peter Flickinger on 10/1/19.
//  Copyright © 2019 Peter Flickinger. All rights reserved.
//

import Foundation
import CoreData

class GoalDataManager {
    let managedObjectContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataManager.shared.backgroundContext) {
        self.managedObjectContext = context
    }
    
    func addGoal(text:String, durration: Int, checkpointLength: Int) -> Goal? {
        let goal = Goal(context: managedObjectContext)
        goal.id = UUID()
        goal.text = text
        
        if(durration > 0){
            goal.durration = Int16(durration)
        } else {
            goal.durration = Int16(100)
        }
        
        goal.checkpointLength = Int16(checkpointLength)
        goal.createdAt = Date()
        goal.completedAt = goal.createdAt
        
        
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
        let sort = NSSortDescriptor(key: "createdAt", ascending: true)
        goalRequest.sortDescriptors = [sort]
        goalRequest.fetchLimit = 1
        
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
        let sort = NSSortDescriptor(key: "createdAt", ascending: false)
        goalRequest.sortDescriptors = [sort]
        
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
        request.fetchLimit = 1
        
        do {
            goals = try self.managedObjectContext.fetch(request)
        } catch let error as NSError {
            print(error)
        }
        
        return goals.first
    }
    
    func editGoal(id:UUID, text:String, durration: Int, checkpointLength: Int) -> Goal? {
        var goal = getGoal(id: id)
        if(text == "" || durration <= 0 || checkpointLength > 10 || checkpointLength < 0){
            return goal // Do not make changes if not allowed
        }
        
        if((goal) != nil){
            goal?.text = text
            if(durration > 0){
                goal?.durration = Int16(durration)
            } else {
                goal?.durration = Int16(100)
            }
            goal?.checkpointLength = Int16(checkpointLength)
            
            do {
                try self.managedObjectContext.save()
            } catch {
                print(error)
            }
        } else {
            goal = addGoal(text: text, durration: durration, checkpointLength: checkpointLength)
        }
        
        return goal
    }
    
    
    func deleteGoal(id: UUID) {
        do {
            if let goal = getGoal(id: id) {
                self.managedObjectContext.delete(goal)
                try self.managedObjectContext.save()
            }
        } catch let error as NSError {
            print(error)
        }
    }

}
