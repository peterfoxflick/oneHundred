//
//  DayView.swift
//  onehundred
//
//  Created by Peter Flickinger on 9/11/19.
//  Copyright © 2019 Peter Flickinger. All rights reserved.
//

import SwiftUI

struct DayView: View {
    @ObservedObject var dayVM = DayViewModel()

    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    init(id: UUID){
        self.dayVM = DayViewModel(id: id)
    }
    
    func save(){
        //save responses
        
    }
    
    var body: some View {
        ScrollView{
            VStack {
                Text("Day \(self.dayVM.count)")
                    .font(.largeTitle)
                
                Text("Checkpoint: \(String(self.dayVM.isCheckpoint))")
        
            
                //Show tasks
                TaskListView(dayID: dayVM.id)
                
                //Show prompts
                ResponseListView(id:self.dayVM.id, parentType: ResponseParentType.Day)

            }
        }
    }
}

//struct DayView_Previews: PreviewProvider {
//    static var previews: some View {
//        DayView()
//    }
//}
