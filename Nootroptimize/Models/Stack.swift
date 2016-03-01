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
    
    
    lazy var logRecords:[LogRecord] = {
        var logRecords = [LogRecord]()
        
        if let logDataSet:NSSet = self.logData {
            let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
             logRecords = logDataSet.sortedArrayUsingDescriptors([sortDescriptor]) as! [LogRecord]
        }
        
        return logRecords
    }()

    lazy var nootropicsData:[Nootropic] = {
        var nootropicsData = [Nootropic]()
        
        if let nootropicsDataSet:NSSet = self.nootropics {
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            nootropicsData = nootropicsDataSet.sortedArrayUsingDescriptors([sortDescriptor]) as! [Nootropic]
        }
        
        return nootropicsData
    }()
    
    
    
    
    // find a log record with matching date (same date components)
    
    func findLogRecordForDate(date:NSDate) {
        
        let unitFlags: NSCalendarUnit = [.Day, .Month, .Year]
        
        let calendar:NSCalendar = NSCalendar.currentCalendar()
        
        let dateComponents:NSDateComponents = calendar.components(unitFlags, fromDate:date)
        
        let day:Int = dateComponents.day
        let month:Int = dateComponents.month
        let year:Int = dateComponents.year
        
        
        if let logDataSet:NSSet = self.logData {
            
            // start with most recent log records
            let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
            logRecords = logDataSet.sortedArrayUsingDescriptors([sortDescriptor]) as! [LogRecord]
            
            for logRecord in logRecords {
               
                let comparisonResult:NSComparisonResult = calendar.compareDate(date, toDate: logRecord.date!, toUnitGranularity: unitFlags)
                
                if comparisonResult == .OrderedSame {
//                    let moc:NSManagedObjectContext = logRecord.managedObjectContext!
//                    moc.deleteObject(logRecord)
//                    moc.insertObject(NSManagedObject)
                    print("same date components")
                    
                    ///TO DO::: instead of deleting and adding a new object just update that log record with new ratings
                    break
                }
                if comparisonResult == .OrderedDescending {
                    break
                }
                
                
            }
        }
        
        
    }

}
