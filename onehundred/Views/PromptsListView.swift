//
//  Prompts.swift
//  onehundred
//
//  Created by Peter Flickinger on 12/15/19.
//  Copyright © 2019 Peter Flickinger. All rights reserved.
//

import SwiftUI

struct PromptsListView: View {
    @ObservedObject var promptListVM = PromptListViewModel()
    @State var newPrompt = ""

    
    private func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            let promptVM = self.promptListVM.prompts[index]
            user.removeDayPrompt(id: promptVM.id)
        }
        promptListVM.fetchAll()
    }
    
    private func save(){
        if(self.newPrompt != ""){
            promptListVM.addDayPrompt(text: self.newPrompt, fill: "")
            self.newPrompt = ""
        }
        promptListVM.fetchAll()        
    }

    var body: some View {
        VStack{
            Text("Day Prompts")
                .font(.title)
            
            List{
                ForEach(self.promptListVM.prompts){ p in
                    
                    VStack{
                        Text(p.text)
                    }
                    
                }.onDelete(perform: delete)
                
                HStack{
                    Button(action: save) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                            .imageScale(.large)
                    }
                    TextField("New Prompt", text: self.$newPrompt, onCommit: save)
                }
            }
            

        }

    }
}

struct Prompts_Previews: PreviewProvider {
    static var previews: some View {
        PromptsListView()
    }
}
