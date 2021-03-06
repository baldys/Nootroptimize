//
//  Stack+CoreDataProperties.swift
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

extension Stack {

    @NSManaged var name: String?
    @NSManaged var dateCreated: NSDate?
    
    // LogRecord Objects
    //
    @NSManaged var logData: NSSet?
    @NSManaged var nootropics: NSSet?
    
    /// category defines how a stack should be evaluated.
    @NSManaged var categories:NSSet?

}
