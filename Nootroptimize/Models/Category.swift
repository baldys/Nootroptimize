//
//  Category.swift
//  Nootroptimize
//
//  Created by Veronica Baldys on 2016-03-02.
//  Copyright © 2016 Veronica Baldys. All rights reserved.
//

import Foundation
import CoreData


class Category: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    class func createInManagedObjectContext(moc:NSManagedObjectContext, stack:Stack, name:String) -> Category {
        let newCategory:Category = NSEntityDescription.insertNewObjectForEntityForName("Category", inManagedObjectContext: moc) as! Category
        newCategory.stack = stack
        newCategory.name = name

        return newCategory
    }
}
