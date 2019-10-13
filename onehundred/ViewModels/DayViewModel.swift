//
//  DayViewModel.swift
//  onehundred
//
//  Created by Peter Flickinger on 9/11/19.
//  Copyright © 2019 Peter Flickinger. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


class DayViewModel: ObservableObject, Identifiable {
    var id:UUID
    @Published var count: Int
    @Published var isCheckpoint: Bool

    init(){
        let day = CoreDataManager.shared.getFirstDay()
        self.id = day?.id ?? UUID()
        self.count = Int(day?.count ?? 1)
        self.isCheckpoint = day?.isCheckpoint ?? false
    }
    
    init(day:Day){
        self.id = day.id ?? UUID()
        self.count = Int(day.count)
        self.isCheckpoint = day.isCheckpoint
    }
    
    init(id: UUID){
        self.id = id
        let day = CoreDataManager.shared.getDay(id: id)
        self.count = Int(day?.count ?? 1)
        self.isCheckpoint = day?.isCheckpoint ?? false
    }

}



