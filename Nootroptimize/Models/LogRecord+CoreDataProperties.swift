//
//  LogRecord+CoreDataProperties.swift
//  Nootroptimize
//
//  Created by Veronica Baldys on 2016-01-27.
//  Copyright © 2016 Veronica Baldys. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension LogRecord {

    @NSManaged var date: NSDate?
    @NSManaged var notes: String?
    @NSManaged var mood: NSNumber?
    @NSManaged var energy: NSNumber?
    @NSManaged var focus: NSNumber?
    @NSManaged var clarity: NSNumber?
    @NSManaged var memory: NSNumber?
    
    @NSManaged var ratings:NSSet?
    
    @NSManaged var stack: Stack?

}
