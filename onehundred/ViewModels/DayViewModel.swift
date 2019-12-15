//
//  DayViewModel.swift
//  onehundred
//
//  Created by Peter Flickinger on 9/11/19.
//  Copyright © 2019 Peter Flickinger. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


class DayViewModel: ObservableObject, Identifiable {
    var id:UUID
    @Published var count: Int
    @Published var isCheckpoint: Bool
    @Published var goalId: UUID

    init(){
        let day = DayDataManager().getFirstDay()
        self.id = day?.id ?? UUID()
        self.count = Int(day?.count ?? 1)
        self.isCheckpoint = day?.isCheckpoint ?? false
        self.goalId = day?.goal?.id ?? UUID()
    }
    
    init(goal: GoalViewModel){
        let day = DayDataManager().addDay(goalID: goal.id)
        self.id = day?.id ?? UUID()
        self.count = Int(day?.count ?? 1)
        self.isCheckpoint = day?.isCheckpoint ?? false
        self.goalId = day?.goal?.id ?? UUID()
    }
    
    init(day:Day){
        self.id = day.id ?? UUID()
        self.count = Int(day.count)
        self.isCheckpoint = day.isCheckpoint
        self.goalId = day.goal?.id ?? UUID()
    }
    
    init(id: UUID){
        self.id = id
        let day = DayDataManager().getDay(id: id)
        self.count = Int(day?.count ?? 1)
        self.isCheckpoint = day?.isCheckpoint ?? false
        self.goalId = day?.goal?.id ?? UUID()
    }
    
    func delete(){
        DayDataManager().deleteDay(id: self.id)
    }

}



