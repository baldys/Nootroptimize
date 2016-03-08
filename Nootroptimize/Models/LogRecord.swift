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
        newLogRecord.ratings = NSSet() as! Set<Rating>



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
    
    class func createInManagedObjectContext(moc:NSManagedObjectContext, stack:Stack, date:NSDate) -> LogRecord {
        
        let newLogRecord = NSEntityDescription.insertNewObjectForEntityForName("LogRecord", inManagedObjectContext: moc) as! LogRecord
        newLogRecord.stack = stack
        newLogRecord.date = date
        
        // get the categories upon which a stack is rated
        for category in stack.categories! {
            let rating:Rating = Rating.createInManagedObjectContext(moc, logRecord: newLogRecord, categoryName: category.name)
            newLogRecord.ratings.insert(rating)
        }
    
        return newLogRecord
    }
    
    func addRating(value:Int, forCategory name:String) {

    }
    
    func getRatingForCategoryName(name:String) -> Int {
        
        
        let predicate = NSPredicate(format: "categoryName == %@", name)
        
        
        let ratingsArray:Array = Array(self.ratings)
        //let ratingValues:[AnyObject] = ratingsArray.filteredArrayUsingPredicate(predicate)
        
        let filteredArray = ratingsArray.filter { predicate.evaluateWithObject($0) }
        
        
        print("names = ,\(filteredArray)");
        
        
        let rating:Rating = filteredArray[0]
        let ratingValue:NSNumber = rating.value!
        
        
        let ratingInt = ratingValue.integerValue
        
        print("ratingValue: \(ratingInt)")
            
        return ratingInt
        
        
    }

    
    func updateLogRecordWithRatings() {
        
    }
}
