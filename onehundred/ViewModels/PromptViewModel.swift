//
//  PromptViewModel.swift
//  onehundred
//
//  Created by Peter Flickinger on 12/15/19.
//  Copyright © 2019 Peter Flickinger. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


class PromptListViewModel: ObservableObject {
    @Published var prompts = [PromptViewModel]()
    var promptDataManger: PromptDataManager
    
    init(){
        promptDataManger = PromptDataManager(context: CoreDataManager.shared.backgroundContext)
        fetchAll()
    }
    
    func fetchAll(){
        let ids = user.dayPrompts
        self.prompts.removeAll()
        for id in ids {
            let p = promptDataManger.getPrompt(id: id)
            if(p != nil){
                let pvm = PromptViewModel(prompt: p!)
                self.prompts.append(pvm)
            }
        }
    }
    
    func deletePrompt(prompt: PromptViewModel){
        promptDataManger.deletePrompt(id: prompt.id)
        fetchAll()
    }
    
    func addPrompt(text: String, fill: String){
        _ = promptDataManger.addPrompt(text: text, fill: fill)
        fetchAll()
    }
    
    func addDayPrompt(text: String, fill: String){
        let prompt = promptDataManger.addPrompt(text: text, fill: fill)
        if(prompt.id != nil){
            user.addDayPrompt(id: prompt.id!)
        }
    }
    
    func removeDayPrompt(id:UUID){
        user.removeDayPrompt(id: id)
        fetchAll()
    }
}


class PromptViewModel: Identifiable {
    var id:UUID
    var text = ""
    var fill = ""

    init(prompt: Prompt){
        self.id = prompt.id ?? UUID()
        self.text = prompt.text ?? ""
        self.fill = prompt.fill ?? ""
    }
}
