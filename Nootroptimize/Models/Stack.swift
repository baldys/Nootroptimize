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
        newItem.categories = NSSet()
        
        newItem.addDefaultCategories()
    
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
    
    func save() {
        do {
            try self.managedObjectContext!.save()
            
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func addDefaultCategories() {
        addCategoryWithName("mood")
      
    }
    
    func addCategoryWithName(name:String) {
        
        if let mutableCategories:NSMutableSet = NSMutableSet(set: categories!) {
            
            let newCategory:Category = Category.createInManagedObjectContext(self.managedObjectContext!, stack: self, name: name)
            
            print(newCategory.name)
            
            mutableCategories.addObject(newCategory)
            self.categories = mutableCategories
            
            // find all dates before the current date in the log record, and add data for all records for this category
            if let logDataSet:NSSet = self.logData {
                
                // start with most recent log records
                let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
                logRecords = logDataSet.sortedArrayUsingDescriptors([sortDescriptor]) as! [LogRecord]
                //var dateSet = Set<NSDate>()
                
                // create new rating object for each log record in the stack, and assign it a value of -1.
                for logRecord in logRecords {
                    //dateSet.insert(logRecord.date)
                    //for rating in logRecord.ratings {
                        //if rating.categoryName == name {
                            Rating.createInManagedObjectContext(self.managedObjectContext!, logRecord: logRecord, categoryName: name)
                        //}
                   // }
                    // if that doesnt work add the rating to LogRecord's set of ratings
                    
                }
            }
            

            save()
        }
    }
    
    func categoryNames() -> [String] {

        var categoryObjects:[Category] = []
        var categoryNames:[String] = []
        //let categoryEntity = NSEntityDescription.entityForName("Category", inManagedObjectContext: self.managedObjectContext!)
        
        //let request = NSFetchRequest()
        //request.entity = categoryEntity

        /// NOTE: THIS CODE FETCHES EVERY CATEGORY FROM EVERY STACK!
       /*
        let request = NSFetchRequest(entityName: "Category")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        do {
            let results = try managedObjectContext!.executeFetchRequest(request)
            
            let categoryArray = results as! [Category]
            for category in categoryArray {
                categoryNames.append(category.name!)
            }
            
        } catch let error as NSError {
            print("could not fetch \(error), \(error.userInfo)")
            
        }
        */
        
        if let categorySet:NSSet = self.categories {
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            categoryObjects = categorySet.sortedArrayUsingDescriptors([sortDescriptor]) as! [Category]
            for category in categoryObjects {
                categoryNames.append(category.name!)
            }
            
        }
        
       
        
        return categoryNames
    }

    func addLogRecordWithDate(date:NSDate) {
        let logRecord:LogRecord = LogRecord.createInManagedObjectContext(self.managedObjectContext!, stack: self, date: date)
        
        addNewLogRecord(logRecord)
    }
    
    func addNewLogRecord(logRecord:LogRecord) {
        if let mutableLogData:NSMutableSet = NSMutableSet(set: logData!) {
            mutableLogData.addObject(logRecord)
            self.logData = mutableLogData
        }
        
        save()
    }
    
    
//    func getLogRecordsForCategory(categoryName:String) -> [NSDate:String] {
//        
//        
//        
//    }
    
    
    
    func addNootropic(nootropic: Nootropic) {
        
        if let mutableNootropicSet:NSMutableSet = NSMutableSet(set: nootropics!) {
            mutableNootropicSet.addObject(nootropic)
            self.nootropics = mutableNootropicSet
            save()
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
