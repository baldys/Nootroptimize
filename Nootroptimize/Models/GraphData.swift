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





class CategorizedGraphPoints {
    var category:String?
    var ratingValues:[Int]?
    
    init(category:String) {
        self.category = category
        self.ratingValues = [0]
    }
    
    func addRating(value:Int) {
        ratingValues?.append(value)
    
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

//    private var moodData:[Int]    = []
//    private var focusData:[Int]   = []
//    private var energyData:[Int]  = []
//    private var clarityData:[Int] = []
//    private var memoryData:[Int]  = []

    //var logRecords:[LogRecord] = []
    var startAtZero:Bool = true
    let dateFormatter = NSDateFormatter()
    
    init(logRecords:[LogRecord], categories:[String]) {

        self.categories = categories
        
        if startAtZero {
            days.append(" ")
            for category in categories {
                let graphPoints = CategorizedGraphPoints(category: category)
                categorizedData.append(graphPoints)
            }
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
    
    func addLogRecord(logRecord:LogRecord) {
        //        logRecords.append(logRecord)
        
        
        
        
        let logRecordDate:NSDate = logRecord.date!
        dates.append(logRecordDate)
        
        
        let dateString = formattedDateString(logRecordDate)
        days.append(dateString)
        
        
        

        for rating in logRecord.ratings {
            
            let categoryName:String = rating.categoryName
            let ratingValue:Int = (rating.value?.integerValue)!
            
            // find the element in categorizedData that has the name

            for graphPoints in categorizedData {
                if graphPoints.category == categoryName {
                    graphPoints.ratingValues?.append(ratingValue)
                }
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
    }
    

    
    
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
    
    
    func ratingValuesForCategory(categoryName:String) -> [Int] {
        
        var ratings:[Int] = []

        for graphPoints in categorizedData {
            if graphPoints.category == categoryName {
                ratings = graphPoints.ratingValues!
                break
            }
            
        }
        return ratings
        

    }

    
    // TO DO::: put this in UIColor extension
    
    func getColourForRatingCategory(category:String) -> [String:UIColor] {
        
        var topColor:UIColor
        var bottomColor:UIColor
        var index:Int = 0
        
        
        for categoryName in categories {
            if categoryName == category {
                index = categories.indexOf(categoryName)!+1
                break
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
            topColor = UIColor.darkGrayColor()
            bottomColor = UIColor.whiteColor()
            break
            
        }
        
        return ["top":topColor, "bottom":bottomColor]
    }
    
    

    
    
}


