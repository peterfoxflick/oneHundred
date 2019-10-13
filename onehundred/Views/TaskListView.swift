//
//  TaskListView.swift
//  onehundred
//
//  Created by Peter Flickinger on 9/11/19.
//  Copyright © 2019 Peter Flickinger. All rights reserved.
//

import SwiftUI

struct TaskListView: View {
    @State var newTask = ""
    var dayID:UUID
    @ObservedObject var taskListVM:TaskListViewModel
    
    init(dayID:UUID){
        self.dayID = dayID
        taskListVM = TaskListViewModel(dayID: dayID)
    }

    private func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            let taskVM = self.taskListVM.tasks[index]
            self.taskListVM.deleteTask(task: taskVM)
        }
    }
    
    private func save(){
        if self.newTask != "" {
            self.taskListVM.addNewTask(title: self.newTask)
            self.newTask = ""
        }
    }

    
    var body: some View {
        List {
            
            ForEach(self.taskListVM.tasks) { task in
                HStack{
                    Button(action: {
                        self.taskListVM.toggleTaskComplete(task: task)
                    }, label: {
                        if(task.isComplete()){
                            Image(systemName: "checkmark.circle")
                                .imageScale(.large)
                        } else {
                            Image(systemName: "circle")
                                .imageScale(.large)
                        }
                    })
                    
                    Text(task.title)
                        .strikethrough(task.isComplete())
                }
            }.onDelete(perform: delete)
            
            if(self.taskListVM.tasks.count < 5){
                HStack{
                    Button(action: save) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                            .imageScale(.large)
                    }
                    TextField("New Item", text: self.$newTask, onCommit: save)
                }
            }
        }.frame(height: 300)
        
    }
}

//struct TaskListView_Previews: PreviewProvider {
//    static var previews: some View {
//        DayView()//TaskListView()
//    }
//}
