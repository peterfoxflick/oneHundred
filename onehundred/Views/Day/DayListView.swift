//
//  DayListView.swift
//  onehundred
//
//  Created by Peter Flickinger on 9/23/19.
//  Copyright © 2019 Peter Flickinger. All rights reserved.
//

import SwiftUI

struct DayListView: View {
    @ObservedObject var goalVM: GoalViewModel
    
    init(goalVM: GoalViewModel){
        self.goalVM = goalVM
    }
    
    var body: some View {
        List(self.goalVM.days.reversed()){ day in
                NavigationLink(destination: DayView(id:day.id)) {
                        Text(String("Day \(day.count)"))
                            .fontWeight(day.isCheckpoint ? Font.Weight.bold : Font.Weight.regular)
                    }
            }
        .frame( minHeight: 300, idealHeight: 500, maxHeight: 800)
    }
}


