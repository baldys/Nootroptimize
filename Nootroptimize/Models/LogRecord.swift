//
//  LogRecord.swift
//  Nootroptimize
//
//  Created by Veronica Baldys on 2016-01-27.
//  Copyright © 2016 Veronica Baldys. All rights reserved.
//

import Foundation
import CoreData

// log record is a set of ratings for a particular date
// there is one rating per category (retreived from the stack) in a log record

class LogRecord: NSManagedObject {
    /*
    @NSManaged var mood: NSNumber?
    @NSManaged var energy: NSNumber?
    @NSManaged var focus: NSNumber?
    @NSManaged var clarity: NSNumber?
    @NSManaged var memory: NSNumber?
    */

    // log record for current date
    class func createInManagedObjectContext(moc:NSManagedObjectContext, stack:Stack, mood:NSNumber, energy:NSNumber, focus:NSNumber, clarity:NSNumber, memory:NSNumber, notes:String) -> LogRecord {
        
        let newLogRecord = NSEntityDescription.insertNewObjectForEntityForName("LogRecord", inManagedObjectContext: moc) as! LogRecord
        newLogRecord.stack = stack
        newLogRecord.date = NSDate()
        newLogRecord.ratings = NSSet()

        var ratings:[Rating]
        // get the categories upon which a stack is rated
        for category in stack.categories {
            let rating:Rating = Rating.createInManagedObjectContext(moc, logRecord: newLogRecord, categoryName: category.name)
            newLogRecord.ratings?.setByAddingObject(rating)
            
        }

        newLogRecord.mood = mood
        newLogRecord.energy = energy
        newLogRecord.focus = focus
        newLogRecord.clarity = clarity
        newLogRecord.memory = memory
        
        newLogRecord.notes = notes
        
        return newLogRecord
    }
    
   
    // log record for specific date
    class func createInManagedObjectContext(moc:NSManagedObjectContext, stack:Stack, date:NSDate, mood:NSNumber, energy:NSNumber, focus:NSNumber, clarity:NSNumber, memory:NSNumber, notes:String) -> LogRecord {
        
        let newLogRecord = NSEntityDescription.insertNewObjectForEntityForName("LogRecord", inManagedObjectContext: moc) as! LogRecord
        newLogRecord.stack = stack
        newLogRecord.date = date
        
        newLogRecord.mood = mood
        newLogRecord.energy = energy
        newLogRecord.focus = focus
        newLogRecord.clarity = clarity
        newLogRecord.memory = memory
        
        newLogRecord.notes = notes
        
        return newLogRecord
    }
    
    func updateLogRecordWithRatings() {
        
    }
}
