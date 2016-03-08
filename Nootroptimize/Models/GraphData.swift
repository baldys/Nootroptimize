//
//  GraphDataManager.swift
//  Nootroptimize
//
//  Created by Veronica Baldys on 2016-02-19.
//  Copyright © 2016 Veronica Baldys. All rights reserved.
//

import Foundation
import UIKit
import CoreData




// number of y values = # xvalues (dates for a rating in a log record)
class CategorizedGraphPoints {
    var category:String
    var ratingValues = [Int]()
    var dates = [String]()
    
    init(category:String) {
        self.category = category
        self.ratingValues = []
        self.dates = []
        
    }
    
    
    func addRating(ratingValue:Int, forDate date:String) {
    
        ratingValues.append(ratingValue)
        dates.append(date)
    
    }
}


class GraphData {
    
    var categorizedData:[CategorizedGraphPoints] = []
    var categories:[String] = []
    
    
    enum RatingType:Int {
        case mood
        case energy
        case focus
        case clarity
        case memory
    }
    
    var dates:[NSDate] = []
    
    var days = [String]()
    
    //var logRecords:[LogRecord] = []
    var startAtZero:Bool = true
    let dateFormatter = NSDateFormatter()
    
    
    init(stack:Stack) {
        
        self.categories = stack.categoryNames()
        
        for category in categories {
            let graphPoints = CategorizedGraphPoints(category: category)
            if startAtZero {
                graphPoints.addRating(0, forDate: " ")
                
            }
            categorizedData.append(graphPoints)
        }
        
        if startAtZero {
            days.append(" ")
            
        }
        
        
        for logRecord in stack.logRecords {
            addLogRecord(logRecord)
            
        }
    }
    
    init(logRecords:[LogRecord], stack:Stack) {

        if logRecords.count == 0 {
            return
        }
        categories = stack.categoryNames()
        
        for category in categories {
            let graphPoints = CategorizedGraphPoints(category: category)
            
            if startAtZero {
                graphPoints.addRating(0, forDate: " ")
                
            }
            
            categorizedData.append(graphPoints)
        }
        
        if startAtZero {
            days.append(" ")
            
        }

        for logRecord in logRecords {
            addLogRecord(logRecord)
        }
        
    }
    
    
//    func fetchRatings(stack:Stack) -> [[Rating]] {
//        let ratings:[Rating]
//        
//        let context:NSManagedObjectContext = stack.managedObjectContext!
//        let logRecordEntity = NSEntityDescription.entityForName("LogRecord", inManagedObjectContext: context)
//        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
//
//        let request = NSFetchRequest()
//        request.entity = logRecordEntity
//        request.relationshipKeyPathsForPrefetching = ["ratings"]
//        request.sortDescriptors = [sortDescriptor]
//        
//        let predicate = NSPredicate(format: "categoryName == %@", stack.categoryNames()[0])
//        request.predicate = predicate
//        
//        do {
//            let results = try context.executeFetchRequest(request)
//            ///stacks = results as! [Stack]
//            
//        } catch let error as NSError {
//            print("could not fetch \(error), \(error.userInfo)")
//            
//        }
//    }
    

    
    func addCategory(name:String, toStack stack:Stack) {
        
        // add category to stack:
        // stack.addCategoryWithName(name)
        
        // new graph category with no values or dates added to it yet
        let newGraphCategory = CategorizedGraphPoints(category: name)
        
        
        if startAtZero {
            
            
        }
        
        for logRecord in stack.logRecords {
            
            let rating = logRecord.getRatingForCategoryName(name)
            print("log record for new category (should be -1) \(rating)")
            
            
        }
        
        categorizedData.append(newGraphCategory)

    }
    
    
    func addLogRecord(logRecord:LogRecord) {
        // assuming a log record has already been added to the stack...?
        // and this log record already has ratings assigned to each category
        
        let logRecordDate:NSDate = logRecord.date!
        dates.append(logRecordDate)

        let dateString = formattedDateString(logRecordDate)
        days.append(dateString)
        
        for graphCategory in categorizedData {
        
            let rating = logRecord.getRatingForCategoryName(graphCategory.category)
//            graphCategory.dates.append(dateString)
            graphCategory.addRating(rating, forDate: dateString)
            

        }


            
    }
  
        
        /*
        if let moodRating:NSNumber = logRecord.mood {
            moodData.append(moodRating.integerValue)
            



        }
        if let energyRating:NSNumber = logRecord.energy {
            energyData.append(energyRating.integerValue)
        }
        if let focusRating:NSNumber = logRecord.focus {
            focusData.append(focusRating.integerValue)
        }
        if let clarityRating:NSNumber = logRecord.clarity {
            clarityData.append(clarityRating.integerValue)
        }
        if let memoryRating:NSNumber = logRecord.memory {
            memoryData.append(memoryRating.integerValue)
        }
        */
    
    

    
    
    func formattedDateString(date:NSDate) -> String {
//        dateFormatter.timeStyle = .ShortStyle
//        dateFormatter.dateStyle = .ShortStyle

        dateFormatter.dateFormat = "dd"
        return dateFormatter.stringFromDate(date)
            
    }
    
//    func getDataForRatingCategory(ratingType:RatingType) -> [Int] {
//        
//        switch ratingType {
//        case .mood:
//
//            return moodData
//        case .energy:
//            return energyData
//        case .focus:
//            return focusData
//        case .clarity:
//             return clarityData
//        case .memory:
//            return memoryData
//        }
//    }
    
    
    func getRatingValuesForCategory(categoryName:String) -> [Int] {
        
        var ratings:[Int] = []

        for graphPoints in categorizedData {
            if graphPoints.category == categoryName {
                ratings = graphPoints.ratingValues
                break
            }
            
        }
        return ratings
        

    }

    func getDatesForCategory(categoryName:String) -> [String] {
        //var dates:[NSDate] = []
        var dateStrings:[String] = []
        
        for graphPoints in categorizedData {
            if graphPoints.category == categoryName {
                
                
                dateStrings = graphPoints.dates
                
                break
            }
            
        }
        
//        for date in dates {
//            dateStrings.append(formattedDateString(date))
//        }
        return dateStrings
    }
    
    // TO DO::: put this in UIColor extension
    
    func getColourForRatingCategory(category:String) -> [String:UIColor] {
        
        var topColor:UIColor
        var bottomColor:UIColor
        var index:Int = 0
        
        var allCategories:[String] = []
        for graphCategory in categorizedData {
            allCategories.append(graphCategory.category)
        }
        
        for aCategory in allCategories {
            if aCategory == category {
                index = allCategories.indexOf(aCategory)!+1
            }
        }
        
        
        switch (index) {
        case 1:
            topColor = UIColor.redGraphColor()
            bottomColor = UIColor.yellowGraphColor()
            break
            
        case 2:
            topColor = UIColor.aquaGraphColour()
            bottomColor = UIColor.turquoiseGraphColour()
            break
            
        case 3:
            topColor = UIColor.yellowColor()
            bottomColor = UIColor.greenGraphColour()
            break
        
        case 4:
            topColor = UIColor.blueGraphColour()
            bottomColor = UIColor.darkPurpleGraphColour()
            break
            
        case 5:
            topColor = UIColor.purpleGraphColour()
            bottomColor = UIColor.pinkGraphColor()
            break
        default:
            topColor = UIColor.blackColor()
            bottomColor = UIColor.lightGrayColor()
            break
            
        }
        
        return ["top":topColor, "bottom":bottomColor]
    }
    
    

    
    
}


