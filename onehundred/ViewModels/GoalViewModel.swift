//
//  GoalViewModel.swift
//  onehundred
//
//  Created by Peter Flickinger on 9/12/19.
//  Copyright © 2019 Peter Flickinger. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class GoalViewModel: ObservableObject, Identifiable {
    var id: UUID
    @Published var text: String
    @Published var checkpointLength: Int
    @Published var durration: Int
    @Published var days: [DayViewModel]
    
    var goalDM = GoalDataManager()
    
    init(text: String, durration: Int, checkpointLength: Int ){
        self.id = UUID()
        self.text = text
        self.checkpointLength = checkpointLength
        self.durration = durration
        self.days = [DayViewModel]()
    }
    
    init(goal:Goal){
        self.id = goal.id ?? UUID()
        self.text = goal.text ?? "???"
        self.checkpointLength = Int(goal.checkpointLength)
        self.durration = Int(goal.durration)
        let tempDays = goal.days?.sorted(by: {($0 as! Day).count < ($1 as! Day).count}) as! [Day]
        self.days = tempDays.map(DayViewModel.init)
    }
    
    init(goalID:UUID){
        self.id = goalID
        let goal = goalDM.getGoal(id: goalID)
        self.text = goal?.text ?? "???"
        self.checkpointLength = Int(goal?.checkpointLength ?? 10)
        self.durration = Int(goal?.durration ?? 403)
        let tempDays = goal?.days?.sorted(by: {($0 as! Day).count < ($1 as! Day).count}) as! [Day]
        self.days = tempDays.map(DayViewModel.init)
    }
    
    func fetch(){
        let goal = goalDM.getGoal(id: self.id)
        self.text = goal?.text ?? "???"
        self.checkpointLength = Int(goal?.checkpointLength ?? 10)
        self.durration = Int(goal?.durration ?? 404)
        let tempDays = goal?.days?.sorted(by: {($0 as! Day).count < ($1 as! Day).count}) as! [Day]
        self.days = tempDays.map(DayViewModel.init)
    }
    
    func save(){
        let _ = goalDM.editGoal(id: self.id, text: self.text, durration: self.durration, checkpointLength: self.checkpointLength)
    }
    
    func delete(){
        goalDM.deleteGoal(id: self.id)
    }
}
