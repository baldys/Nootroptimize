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

    class func createInManagedObjectContext(moc:NSManagedObjectContext, logRecord:LogRecord, category:Category, value:Int) -> Rating {
        let rating:Rating = NSEntityDescription.insertNewObjectForEntityForName("Rating", inManagedObjectContext: moc) as! Rating
        rating.logRecord = logRecord
        rating.category = category
        rating.value = value
        
        
        
        return rating
    }
    
}
