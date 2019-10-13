//
//  DayDataManager.swift
//  onehundred
//
//  Created by Peter Flickinger on 10/2/19.
//  Copyright © 2019 Peter Flickinger. All rights reserved.
//

import Foundation
import CoreData

class DayDataManager {
    let managedObjectContext: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataManager.shared.backgroundContext) {
        self.managedObjectContext = context
    }
    
    
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
        let goal = GoalDataManager(context: managedObjectContext).getGoal(id: goalID)
        let days = goal?.days
        
        //Values of day
        let id = UUID()
        day.id = id
        day.createdAt = Date()
        
        if(days?.count == 0) {
            day.count = 1
        } else {
            day.count = Int16(days?.count ?? 0) + 1
        }
        
        day.isCheckpoint = (day.count - 1) % (goal?.checkpointLength ?? 10) == 0
        
        // Add to goal
        day.goal = goal
        
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
        let sort = NSSortDescriptor(key: "createdAt", ascending: true)
        dayRequest.sortDescriptors = [sort]
        dayRequest.fetchLimit = 1

        
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
    
    func deleteDay(id: UUID) {
        do {
            if let day = getDay(id: id) {
                self.managedObjectContext.delete(day)
                try self.managedObjectContext.save()
            }
        } catch let error as NSError {
            print(error)
        }
    }

}




