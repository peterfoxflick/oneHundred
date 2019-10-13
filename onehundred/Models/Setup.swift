//
//  promptSetup.swift
//  onehundred
//
//  Created by Peter Flickinger on 9/11/19.
//  Copyright © 2019 Peter Flickinger. All rights reserved.
//

import Foundation

class Setup{
    //I am gratefull for:
    // Wonderfull things
    
    func dayPrompts() -> [UUID] {
        var prompts = [UUID]()
        
        // Gratitud
        var prompt = CoreDataManager.shared.addPrompt(text: "Today I’m grateful for:", fill: "my great friend Susan")
        if prompt.id != nil {
            prompts.append(prompt.id!)
        }
        
        // Struggles
        prompt = CoreDataManager.shared.addPrompt(text: "Struggles encountered:", fill: "focusing for two hours on homework")
        if prompt.id != nil {
            prompts.append(prompt.id!)
        }
        // Possible solutions:
        prompt = CoreDataManager.shared.addPrompt(text: "Possible solutions:", fill: "take a break ever 30 minutes to walk arround the library.")
        if prompt.id != nil {
            prompts.append(prompt.id!)
        }
        // Thoughts for the day:
        prompt = CoreDataManager.shared.addPrompt(text: "Additional thoughts:", fill: "Take a moment to reflect and treat this as a journal entry")
        if prompt.id != nil {
            prompts.append(prompt.id!)
        }
        return prompts
    }
    
    func goalPrompts() -> [UUID] {
        var prompts = [UUID]()
        
        // What is your goal:
        var prompt = CoreDataManager.shared.addPrompt(text: "What is your goal:", fill: "Run a half marathon")
        if prompt.id != nil {
            prompts.append(prompt.id!)
        }
        // Why is this important to you?
        prompt = CoreDataManager.shared.addPrompt(text: "Why is this important to you?", fill: "Improve my health, live longer, be happier")
        if prompt.id != nil {
            prompts.append(prompt.id!)
        }
        // How can you measure the success of your goal?
        prompt = CoreDataManager.shared.addPrompt(text: "How can you measure the success of your goal?", fill: "Registering for the local marathon run in 110 days")
        if prompt.id != nil {
            prompts.append(prompt.id!)
        }
        // What tools do you need?
        prompt = CoreDataManager.shared.addPrompt(text: "What tools do you need?", fill: "Running shoes, fitness tracking app")
        if prompt.id != nil {
            prompts.append(prompt.id!)
        }
        // Who will be able to help you along the way?
        prompt = CoreDataManager.shared.addPrompt(text: "Who will be able to help you along the way?", fill: "Susan, Mike and my running club")
        if prompt.id != nil {
            prompts.append(prompt.id!)
        }
        return prompts
    }
    
    func goal() -> Goal {
        let goalDM = GoalDataManager()
        let dayDM = DayDataManager()
        
        
        if(goalDM.getAllGoals().count > 0){
            return goalDM.getFirstGoal() ?? Goal()
        }
        
        let goal = goalDM.addGoal(text: "Code", durration: 100, checkpointLength: 10) ?? Goal()

        if(goal.id != nil){
            for _ in 1...37 {
                let _ = dayDM.addDay(goalID: goal.id!)
            }
        }
        
        return goal
    }
}



