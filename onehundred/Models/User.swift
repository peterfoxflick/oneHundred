//
//  User.swift
//  onehundred
//
//  Created by Peter Flickinger on 9/12/19.
//  Copyright © 2019 Peter Flickinger. All rights reserved.
//

import Foundation

let user = User()

class User {
    var goalPrompts:[UUID] = [UUID]()
    var checkpointPrompts:[UUID] = [UUID]()
    var dayPrompts:[UUID] = [UUID]()

    init(){
        fetch()
    }
    
    func save(){
        let defaults = UserDefaults.standard
        defaults.set(self.goalPrompts, forKey: "GoalPrompts")
        defaults.set(self.checkpointPrompts, forKey: "GoalPrompts")
        defaults.set(self.dayPrompts, forKey: "GoalPrompts")
    }
    
    func fetch(){
        let defaults = UserDefaults.standard
        self.goalPrompts = defaults.object(forKey: "GoalPrompts") as? [UUID] ?? [UUID]()
        self.checkpointPrompts = defaults.object(forKey:  "GoalPrompts") as? [UUID] ?? [UUID]()
        self.dayPrompts = defaults.object(forKey: "GoalPrompts") as? [UUID] ?? [UUID]()
    }
}
