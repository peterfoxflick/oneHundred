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
    
    func save(){
        responseListVM.save()
    }
    
    
    var body: some View {
            VStack{
                ForEach(self.responseListVM.responses){ response in
                    ResponseView(response: response)
                }
                
                Button(action: save) {
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(.green)
                        .imageScale(.large)
                }
                
            }.padding()
        
        
    }
}

struct ResponseView: View {
    @State var response :ResponseViewModel
    
    func save(escape:Bool = false) {
        print("Answer is \(self.response.answer)")
        self.response.save()
    }
    func save() {
        print("Answer is \(self.response.answer)")
        self.response.save()
    }
    
    var body: some View {
        VStack{
            Text(response.prompt)
                .lineLimit(nil)
            
//            TextField(self.response.prompt, text: self.$response.answer).lineLimit(8)
//                .frame(width: 300, height: 200)
            
//            MultilineTextView(text: $response.answer)
//            .overlay(
//                   RoundedRectangle(cornerRadius: 16)
//                    .stroke(Color.gray, lineWidth: 2)
//               )
                
                
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

struct MultilineTextView: UIViewRepresentable {
    @Binding var text: String

    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.isScrollEnabled = true
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.font = UIFont.systemFont(ofSize: 17.0)
        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}


//struct ResponseListView_Previews: PreviewProvider {
//    static var previews: some View {
//        GoalView()//ResponseView()
//    }
//}
