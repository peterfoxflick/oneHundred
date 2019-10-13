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
    
    var body: some View {
        
        NavigationView {
            List(self.goalsVM.goals) { goal in
                NavigationLink(destination: GoalHost(goalVM: goal)) {
                    Text("\(goal.durration) days of \(goal.text)")
                }
            }
            .navigationBarTitle(Text("Goals"))
        }
    }
}

struct GoalListView_Previews: PreviewProvider {
    static var previews: some View {
        GoalListView()
    }
}
