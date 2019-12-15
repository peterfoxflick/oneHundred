//
//  GoalView.swift
//  onehundred
//
//  Created by Peter Flickinger on 9/12/19.
//  Copyright © 2019 Peter Flickinger. All rights reserved.
//

import SwiftUI

struct GoalView: View {
    @ObservedObject var goalVM: GoalViewModel
    @State var showEditor:Bool = false
    @State var showNewDay:Bool = false

                
    init(goalID: UUID){
        self.goalVM = GoalViewModel(goalID: goalID)
    }
    
    init(goalVM: GoalViewModel){
        self.goalVM = goalVM
    }
    
    func deleteDay(){
        goalVM.days.last?.delete()
        goalVM.fetch()
    }
    
    var body: some View{
        VStack{
            
            Text("\(self.goalVM.durration) days of \(self.goalVM.text)")
                .font(.title)
            
            Text("\(self.goalVM.days.count) days completed")
            Text("\(self.goalVM.durration - self.goalVM.days.count) days remaining")
            Text("Checkpoints every \(self.goalVM.checkpointLength) days")


            DayListView(goalVM: self.goalVM)
            
            
        }
        .navigationBarItems(trailing:
            HStack{
                
                Image(systemName: "gear")
                .imageScale(.large).onTapGesture {
                    self.showEditor = true;
                }.sheet(isPresented: $showEditor, content: {
                GoalEditor(goalVM: self.goalVM, isPresented: self.$showEditor);
                })
                
                
                
                
                if(self.goalVM.days.count > 0) {
                    Image(systemName: "minus.circle")
                        .foregroundColor(.red)
                        .imageScale(.large).onTapGesture {
                            self.deleteDay()
                        }
                }
                
                
                if(self.goalVM.days.count < self.goalVM.durration) {
                    Image(systemName: "square.and.pencil")
                        .imageScale(.large).onTapGesture {
                            self.showNewDay = true;
                        }.sheet(isPresented: $showNewDay, onDismiss: {
                            self.goalVM.fetch()
                        }, content: {
                            DayView(id: DayViewModel(goal: self.goalVM).id)
                        })
                }

                
            }.padding()
        )


         


    }


    
}


 
 

//struct GoalView_Previews: PreviewProvider {
//    static var previews: some View {
//        GoalView()
//    }
//}
