//
//  TaskListViewModel.swift
//  onehundred
//
//  Created by Peter Flickinger on 9/11/19.
//  Copyright © 2019 Peter Flickinger. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


class TaskListViewModel: ObservableObject {
    
    var dayID:UUID
    @Published var tasks = [TaskViewModel]()
    var taskDataManger: TaskDataManager
    
    init(dayID:UUID){
        self.dayID = dayID
        taskDataManger = TaskDataManager(context: CoreDataManager.shared.backgroundContext)
        fetchAllOrders()
    }
    
    func fetchAllOrders(){
        self.tasks = taskDataManger.getTasksFromDay(dayID: self.dayID).map(TaskViewModel.init)
    }
    
    func deleteTask(task: TaskViewModel){
        taskDataManger.deleteTask(id: task.id)
        fetchAllOrders()
    }
    
    func addNewTask(title: String){
        _ = taskDataManger.addTask(title: title, createdAt: Date(), dayID: dayID)
        fetchAllOrders()
    }
    
    func toggleTaskComplete(task: TaskViewModel){
        if(task.isComplete()){
            task.completedAt = task.createdAt
        } else {
            task.completedAt = Date()
        }
        _ = taskDataManger.updateTask(id:task.id, completedAt: task.completedAt)
        fetchAllOrders()
    }
}


class TaskViewModel: Identifiable {
    var id:UUID
    var title = ""
    var createdAt:Date?
    var completedAt:Date?
    
    init(task: Task){
        self.id = task.id ?? UUID()
        self.title = task.title ?? "Error, task not found"
        self.createdAt = task.createdAt
        self.completedAt = task.completedAt
    }
    
    func isComplete() -> Bool {
        if(self.createdAt != self.completedAt){
            return true
        }
        return false
    }
}
