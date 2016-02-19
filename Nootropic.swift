//
//  Nootropic.swift
//  Nootroptimize
//
//  Created by Veronica Baldys on 2016-01-27.
//  Copyright © 2016 Veronica Baldys. All rights reserved.
//

import Foundation
import CoreData


class Nootropic: NSManagedObject {


    
// Insert code here to add functionality to your managed object subclass

    class func createInManagedObjectContext(moc:NSManagedObjectContext, stack:Stack, name:String, dose:NSNumber, frequency:String) -> Nootropic {
        
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("Nootropic", inManagedObjectContext: moc) as! Nootropic
        newItem.stack = stack
        newItem.name = name
        newItem.dose = dose
        newItem.frequency = frequency
        newItem.dateAdded = NSDate()
        return newItem
    }
   

    

}
