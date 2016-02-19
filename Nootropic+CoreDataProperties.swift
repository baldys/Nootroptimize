//
//  Nootropic+CoreDataProperties.swift
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

extension Nootropic {

    @NSManaged var name: String?
    @NSManaged var dose: NSNumber?
    @NSManaged var frequency: String?
    @NSManaged var dateAdded: NSDate?
    @NSManaged var stack: Stack?

}
