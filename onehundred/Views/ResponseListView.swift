//
//  ResponseView.swift
//  onehundred
//
//  Created by Peter Flickinger on 9/12/19.
//  Copyright © 2019 Peter Flickinger. All rights reserved.
//

import SwiftUI

struct ResponseListView: View {
    @ObservedObject var responseListVM:ResponseListViewModel
    let id:UUID
    
    init(id:UUID, parentType: ResponseParentType){
        self.id = id
        self.responseListVM = ResponseListViewModel(parentID: self.id, parentType: parentType)
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack{
                ForEach(self.responseListVM.responses){ response in
                    ResponseView(response: response)
                }
                
            }
        }
    }
}

struct ResponseView: View {
    @State var response :ResponseViewModel
    
    func save() {
        self.response.save()
    }
    
    func save(onEnter:Bool){
        if(onEnter) {
            self.response.save()
        }
    }
    
    var body: some View {
        VStack{
            Text(response.prompt)
                .lineLimit(nil)
            
            TextField("Fill", text: $response.answer, onEditingChanged: save, onCommit: save)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onDisappear(perform: {
                        self.response.save()
                    })
            .lineLimit(10)
            .frame(width: 300, height: 200)
            
        }.frame(width: 300, height: 300)
    }
        
}

//struct ResponseListView_Previews: PreviewProvider {
//    static var previews: some View {
//        GoalView()//ResponseView()
//    }
//}
