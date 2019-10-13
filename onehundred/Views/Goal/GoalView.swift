//
//  GoalView.swift
//  onehundred
//
//  Created by Peter Flickinger on 9/12/19.
//  Copyright © 2019 Peter Flickinger. All rights reserved.
//

import SwiftUI

struct GoalView: View {
    @ObservedObject var goalVM: GoalViewModel
                
    init(goalID: UUID){
        self.goalVM = GoalViewModel(goalID: goalID)
    }
    
    init(goalVM: GoalViewModel){
        self.goalVM = goalVM
    }
    
    var body: some View{
        VStack{
            
            Text("\(self.goalVM.durration) days of \(self.goalVM.text)")
                .font(.title)
            
            Text("\(self.goalVM.days.count) days completed")
            Text("\(self.goalVM.durration - self.goalVM.days.count) days remaining")
            Text("Checkpoints every \(self.goalVM.checkpointLength) days")


            DayListView(goalVM: self.goalVM)
            
            
        }
    }


    
}


 
 

//struct GoalView_Previews: PreviewProvider {
//    static var previews: some View {
//        GoalView()
//    }
//}
