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
        
        let stringDayPrompt = self.dayPrompts.map{ $0.uuidString }
//        defaults.set(self.goalPrompts, forKey: "goalPrompts")
//        defaults.set(self.checkpointPrompts, forKey: "checkpointPrompts")
        defaults.set(stringDayPrompt, forKey: "dayPrompts")
    }
    
    func fetch(){
        self.dayPrompts.removeAll()

        
        
        let defaults = UserDefaults.standard
//        self.goalPrompts = defaults.object(forKey: "goalPrompts") as? [UUID] ?? [UUID]()
//        self.checkpointPrompts = defaults.object(forKey:  "checkpointPrompts") as? [UUID] ?? [UUID]()
        let stringDayPrompts = defaults.object(forKey: "dayPrompts") as? [String] ?? [String]()
        
        
        for id in stringDayPrompts {
            let uid = UUID.init(uuidString: id)
            
            if(uid != nil){
                self.dayPrompts.append(uid!)
            }
        }
    }
    
    func addDayPrompt(id:UUID){
        self.dayPrompts.append(id)
        save()
    }
    
    func removeDayPrompt(id:UUID){
        if let index = self.dayPrompts.firstIndex(of: id) {
            self.dayPrompts.remove(at: index)
        }
        save()
    }
}
