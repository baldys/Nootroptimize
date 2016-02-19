//
//  Stack.swift
//  Nootroptimize
//
//  Created by Veronica Baldys on 2016-01-27.
//  Copyright © 2016 Veronica Baldys. All rights reserved.
//

import Foundation
import CoreData


class Stack: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    class func createInManagedObjectContext(moc:NSManagedObjectContext, name:String) -> Stack {
        
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("Stack", inManagedObjectContext: moc) as! Stack
        newItem.name = name
        newItem.dateCreated = NSDate()
        newItem.nootropics = NSSet()
        newItem.logData = NSSet()
        
        return newItem
    }
    
    class func createInManagedObjectContext(moc:NSManagedObjectContext, name:String, nootropics:NSSet) -> Stack {
        
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("Stack", inManagedObjectContext: moc) as! Stack
        newItem.name = name
        newItem.dateCreated = NSDate()
        newItem.nootropics = nootropics
        newItem.logData = NSSet()
        
        return newItem
    }
    

    
    func addNewLogRecord(logRecord:LogRecord) {
        if let mutableLogData:NSMutableSet = NSMutableSet(set: logData!) {
            mutableLogData.addObject(logRecord)
            self.logData = mutableLogData

        }
    
        //NSSet.mutableSetValueForKey()
    }
    
    func addNootropic(nootropic: Nootropic) {
        
        if let mutableNootropicSet:NSMutableSet = NSMutableSet(set: nootropics!) {
            mutableNootropicSet.addObject(nootropic)
            self.nootropics = mutableNootropicSet
            
        }
    }
    
    

        
    
}
