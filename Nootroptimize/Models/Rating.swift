//
//  Rating.swift
//  Nootroptimize
//
//  Created by Veronica Baldys on 2016-03-02.
//  Copyright © 2016 Veronica Baldys. All rights reserved.
//

import Foundation
import CoreData


class Rating: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    class func createInManagedObjectContext(moc:NSManagedObjectContext, logRecord:LogRecord, categoryName:String, value:Int) -> Rating {
        let rating:Rating = NSEntityDescription.insertNewObjectForEntityForName("Rating", inManagedObjectContext: moc) as! Rating
        rating.logRecord = logRecord
        rating.value = value
        rating.categoryName = categoryName
        
        
        return rating
    }
    class func createInManagedObjectContext(moc:NSManagedObjectContext, logRecord:LogRecord, categoryName:String) -> Rating {
        
        let rating:Rating = NSEntityDescription.insertNewObjectForEntityForName("Rating", inManagedObjectContext: moc) as! Rating
        rating.logRecord = logRecord
        rating.value = 0
        rating.categoryName = categoryName


        return rating
    }

    
    
}
