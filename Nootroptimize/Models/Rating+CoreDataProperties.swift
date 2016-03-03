//
//  Rating+CoreDataProperties.swift
//  Nootroptimize
//
//  Created by Veronica Baldys on 2016-03-02.
//  Copyright © 2016 Veronica Baldys. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Rating {

    // the actual rating value assigned to a category for a stack on the given date (in the log record)
    @NSManaged var value: NSNumber?
    //@NSManaged var category: Category?
    @NSManaged var categoryName: String!
    @NSManaged var logRecord: LogRecord?

}
