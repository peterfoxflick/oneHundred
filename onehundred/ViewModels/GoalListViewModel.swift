//
//  GoalListViewModel.swift
//  onehundred
//
//  Created by Peter Flickinger on 9/18/19.
//  Copyright © 2019 Peter Flickinger. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class GoalListViewModel: ObservableObject {
    @Published var goals = [GoalViewModel]()

    init(){
        fetchAllGoals()
    }
    
    func fetchAllGoals(){
        goals = GoalDataManager().getAllGoals().map(GoalViewModel.init)
    }
    
    func delete(id: UUID){
        GoalDataManager().deleteGoal(id: id)
        fetchAllGoals()
    }
}
