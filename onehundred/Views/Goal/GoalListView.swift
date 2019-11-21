//
//  GoalListView.swift
//  onehundred
//
//  Created by Peter Flickinger on 9/18/19.
//  Copyright © 2019 Peter Flickinger. All rights reserved.
//

import SwiftUI

struct GoalListView: View {
    @ObservedObject var goalsVM:GoalListViewModel = GoalListViewModel()
    @State var showNewGoal:Bool = false
    @State var newGoal:GoalViewModel = GoalViewModel(text: "", durration: 100, checkpointLength: 10)
    
    
    func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            let goalVM = self.goalsVM.goals[index]
            self.goalsVM.delete(id: goalVM.id)
        }
    }
    
    func update(){
        self.goalsVM.fetchAllGoals()
    }
    
    var body: some View {
        
        NavigationView {
            List{
                ForEach(self.goalsVM.goals){ goal in
                    NavigationLink(destination: GoalView(goalVM: goal)) {
                        Text("\(goal.durration) days of \(goal.text)")
                    }
                }
            .onDelete(perform: delete)
            .onAppear(perform: update)
            }.sheet(isPresented: $showNewGoal, content: {
                GoalEditor(goalVM: self.newGoal, isPresented: self.$showNewGoal)
                    .onDisappear(perform: {
                        self.update()
                        self.newGoal = GoalViewModel(text: "", durration: 100, checkpointLength: 10)

                    })
                })
            .navigationBarTitle(Text("Goals"))
            .navigationBarItems(
                trailing:
                Image(systemName: "plus.circle.fill")
                .imageScale(.large).onTapGesture {
                    self.showNewGoal = true;
                })
        }
    }
}

struct GoalListView_Previews: PreviewProvider {
    static var previews: some View {
        GoalListView()
    }
}
