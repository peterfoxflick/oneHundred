//
//  CoreDataTestManager.swift
//  onehundredTests
//
//  Created by Peter Flickinger on 9/30/19.
//  Copyright © 2019 Peter Flickinger. All rights reserved.
//

import Foundation
import CoreData


class CoreDataTestStack {

    //From https://williamboles.me/can-unit-testing-and-core-data-become-bffs/
    
    
    let persistentContainer: NSPersistentContainer
    let backgroundContext: NSManagedObjectContext
    let mainContext: NSManagedObjectContext

    init() {
        persistentContainer = NSPersistentContainer(name: "onehundred")
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.type = NSInMemoryStoreType

        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("was unable to load store \(error!)")
            }
        }
        
        mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.automaticallyMergesChangesFromParent = true
        mainContext.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator

        backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        backgroundContext.parent = self.mainContext
    }
}
