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
    
    
    func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            let goalVM = self.goalsVM.goals[index]
            self.goalsVM.delete(id: goalVM.id)
        }
    }
    
    var body: some View {
        
        NavigationView {
            List{
                ForEach(self.goalsVM.goals){ goal in
                    NavigationLink(destination: GoalHost(goalVM: goal)) {
                        Text("\(goal.durration) days of \(goal.text)")
                    }
                }
            .onDelete(perform: delete)
            }
            .navigationBarTitle(Text("Goals"))
//            .navigationBarItems(trailing: NavigationLink(destination: GoalHost(goalVM: draftGoalVM, edit: true), label:{
//                Image(systemName: "plus.circle.fill")
//                    .imageScale(.large)})).onTapGesture {
//                        self.goalsVM.fetchAllGoals()
//            }
            
        }
    }
}

struct GoalListView_Previews: PreviewProvider {
    static var previews: some View {
        GoalListView()
    }
}
