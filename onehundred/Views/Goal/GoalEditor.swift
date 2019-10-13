//
//  GoalEditor.swift
//  onehundred
//
//  Created by Peter Flickinger on 10/1/19.
//  Copyright © 2019 Peter Flickinger. All rights reserved.
//

import SwiftUI

struct GoalEditor: View {
    @ObservedObject var goalVM: GoalViewModel
    

    
    init(goalVM: GoalViewModel){
        self.goalVM = goalVM
    }
    
    private var numberFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        return f
    }()

    
    var body: some View {
        let durrationProxy = Binding<String>(
            get: { String(format: "%i", Int(self.goalVM.durration)) },
            set: {
                if let value = NumberFormatter().number(from: $0) {
                    self.goalVM.durration = value.intValue
                }
            }
        )

        return ScrollView{
            VStack{
                Group {
                    VStack {
                        Text("How many days should your goal last?")
                            .lineLimit(nil)
                        TextField("100", text: durrationProxy)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: CGFloat(100), alignment: .center)
                            .multilineTextAlignment(.center)
                            .keyboardType(.numberPad)
                    }
                }
                
                Group {
                    VStack{
                        Text("Now what is your vision for these days, or one word to describe your overarching goal:")
                            .lineLimit(nil)
                        TextField("meditation, code, health", text: self.$goalVM.text)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 200, alignment: .center)
                            .multilineTextAlignment(.center)
                    }
                }
                
                
                Group {
                    VStack{
                        Text("Your vision will be seperated into different milestones called checkpoints. How often would you like these checkpoints to occure?")
                            .lineLimit(6)
                        Picker(selection: self.$goalVM.checkpointLength, label: Text("")) {
                            Text("5 days").tag(5)
                            Text("7 days").tag(7)
                            Text("10 days").tag(10)
                        }.pickerStyle(SegmentedPickerStyle())
                        
                    }
                }
                
            }
        }
    }
}





//struct GoalEditor_Previews: PreviewProvider {
//    static var previews: some View {
//        GoalEditor()
//    }
//}
