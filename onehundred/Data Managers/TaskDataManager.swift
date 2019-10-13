//
//  TasksDataManager.swift
//  onehundred
//
//  Created by Peter Flickinger on 9/30/19.
//  Copyright © 2019 Peter Flickinger. All rights reserved.
//
import Foundation
import CoreData

class TaskDataManager {
    let managedObjectContext: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataManager.shared.backgroundContext) {
        self.managedObjectContext = context
    }

    
    
    // MARK: Tasks
    func addTask(title:String, createdAt: Date, dayID:UUID) -> Task {
        let task = Task(context: managedObjectContext)
        task.id = UUID()
        task.title = title
        task.createdAt = createdAt
        task.completedAt = createdAt
        
        //add to a day
        let day = DayDataManager(context: self.managedObjectContext).getDay(id: dayID)
        task.day = day
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error)
        }
        
        return task
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
        let day = DayDataManager(context: self.managedObjectContext).getDay(id: dayID)
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
        request.fetchLimit = 1

        
        do {
            tasks = try self.managedObjectContext.fetch(request)
        } catch let error as NSError {
            print(error)
        }
        
        return tasks.first
    }
    
    func updateTask(id:UUID, title:String? = nil, createdAt:Date? = nil, completedAt:Date? = nil) -> Task? {
        let task = getTask(id: id)

        task?.title = title ?? task?.title
        task?.createdAt = createdAt ?? task?.createdAt
        task?.completedAt = completedAt ?? task?.completedAt
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error)
        }
        
        return task
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
    
    
}
