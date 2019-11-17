//
//  ResponseListViewModel.swift
//  onehundred
//
//  Created by Peter Flickinger on 9/12/19.
//  Copyright © 2019 Peter Flickinger. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import CoreData

class ResponseListViewModel: ObservableObject {
    private var parentID: UUID
    private var parentType: ResponseParentType
    @Published var responses = [ResponseViewModel]()
    
    var responseDM = ResponseDataManager()


    
    init(parentID:UUID, parentType:ResponseParentType){
        self.parentID = parentID
        self.parentType = parentType
        fetchAll()
        
        //Set up a new one if necessary
        if (self.responses.count == 0) {
            let prompts = getAllPrompts()
            for (index, promptID) in prompts.enumerated() {
                responseDM.addNewResponseToParent(promptID:promptID, parentID:self.parentID, order:index, parentType: self.parentType)
            }
            fetchAll()
        }
    }
    
    func fetchAll(){
        self.responses = responseDM.getResponsesFromParent(parentType: self.parentType, parentID: self.parentID).map(ResponseViewModel.init).sorted(by: { return $0.order < $1.order})
    }
    
    func getAllPrompts() -> [UUID]{
        switch self.parentType {
        case .Goal:
            return user.goalPrompts
        case .Day:
            return user.dayPrompts
        }
    }
}



class ResponseViewModel: Identifiable {
    var id:UUID
    var answer:String
    var prompt:String
    var order:Int
    
    init(response: Response){
        self.id = response.id ?? UUID()
        self.answer = response.answer ?? response.prompt?.fill ?? "Type here"
        self.prompt = response.prompt?.text ?? "Notes:"
        self.order = Int(response.order)
    }
    
    func save(){
        ResponseDataManager().updateResponse(id:id, answer:answer)
    }
}
