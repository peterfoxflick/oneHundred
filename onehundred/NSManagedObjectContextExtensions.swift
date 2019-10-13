//
//  NSManagedObjectContextExtensions.swift
//  onehundred
//
//  Created by Peter Flickinger on 9/10/19.
//  Copyright © 2019 Peter Flickinger. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension NSManagedObjectContext {
    static var current: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
