//
//  promptSetup.swift
//  onehundred
//
//  Created by Peter Flickinger on 9/11/19.
//  Copyright © 2019 Peter Flickinger. All rights reserved.
//

import Foundation

class Setup{
    func run(){
        let _ = goal()
        
        user.fetch()
        
        if(user.dayPrompts.count == 0){
            user.dayPrompts = self.dayPrompts()
        }
    }
    
    func dayPrompts() -> [UUID] {
        var prompts = [UUID]()
        
        let promptDM = PromptDataManager()

        
        // Gratitud
        var prompt = promptDM.addPrompt(text: "Today I’m grateful for:", fill: "my great friend Susan")
        if prompt.id != nil {
            prompts.append(prompt.id!)
        }
        
        // Struggles
        prompt = promptDM.addPrompt(text: "Struggles encountered:", fill: "focusing for two hours on homework")
        if prompt.id != nil {
            prompts.append(prompt.id!)
        }
        // Possible solutions:
        prompt = promptDM.addPrompt(text: "Possible solutions:", fill: "take a break ever 30 minutes to walk arround the library.")
        if prompt.id != nil {
            prompts.append(prompt.id!)
        }
        // Thoughts for the day:
        prompt = promptDM.addPrompt(text: "Additional thoughts:", fill: "Take a moment to reflect and treat this as a journal entry")
        if prompt.id != nil {
            prompts.append(prompt.id!)
        }
        return prompts
    }
    
    func goalPrompts() -> [UUID] {
        var prompts = [UUID]()
        
        let promptDM = PromptDataManager()
        
        // What is your goal:
        var prompt = promptDM.addPrompt(text: "What is your goal:", fill: "Run a half marathon")
        if prompt.id != nil {
            prompts.append(prompt.id!)
        }
        // Why is this important to you?
        prompt = promptDM.addPrompt(text: "Why is this important to you?", fill: "Improve my health, live longer, be happier")
        if prompt.id != nil {
            prompts.append(prompt.id!)
        }
        // How can you measure the success of your goal?
        prompt = promptDM.addPrompt(text: "How can you measure the success of your goal?", fill: "Registering for the local marathon run in 110 days")
        if prompt.id != nil {
            prompts.append(prompt.id!)
        }
        // What tools do you need?
        prompt = promptDM.addPrompt(text: "What tools do you need?", fill: "Running shoes, fitness tracking app")
        if prompt.id != nil {
            prompts.append(prompt.id!)
        }
        // Who will be able to help you along the way?
        prompt = promptDM.addPrompt(text: "Who will be able to help you along the way?", fill: "Susan, Mike and my running club")
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



