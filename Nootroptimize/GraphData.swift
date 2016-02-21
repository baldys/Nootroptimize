//
//  GraphDataManager.swift
//  Nootroptimize
//
//  Created by Veronica Baldys on 2016-02-19.
//  Copyright © 2016 Veronica Baldys. All rights reserved.
//

import Foundation
import UIKit

class GraphData {
    
    enum RatingType:Int {
        case mood
        case energy
        case focus
        case clarity
        case memory
    }
    
    var days:[String] = []
    
    private var moodData:[Int] = []
    var focusData:[Int] = []
    var energyData:[Int] = []
    var clarityData:[Int] = []
    var memoryData:[Int] = []

    var logRecords:[LogRecord] = []
    
    let dateFormatter = NSDateFormatter()
    
    init(logRecords:[LogRecord]) {

        self.logRecords = logRecords
 
        if (logRecords.count > 0) {
            for logRecord in logRecords {
                addLogRecord(logRecord)
            }
        }
    }

    
    
    func formattedDateString(date:NSDate) -> String {
            
        dateFormatter.dateFormat = "dd"
        return dateFormatter.stringFromDate(date)
            
    }
    
    func getDataForRatingCategory(ratingType:RatingType) -> [Int] {
        
        switch ratingType {
        case .mood:
            return moodData
        case .energy:
            return energyData
        case .focus:
            return focusData
        case .clarity:
             return clarityData
        case .memory:
            return memoryData
        }
    }
    
    // TO DO::: put this in UIColor extension
    
    func getColourForRatingCategory(ratingType:RatingType) -> [String:UIColor] {
        
        var topColor:UIColor
        var bottomColor:UIColor
        
        switch ratingType {
        case .mood:
            topColor = UIColor.redGraphColor()
            bottomColor = UIColor.yellowGraphColor()
            break
            
        case .energy:
            topColor = UIColor.aquaGraphColour()
            bottomColor = UIColor.turquoiseGraphColour()
            break
            
        case .focus:
            topColor = UIColor.yellowColor()
            bottomColor = UIColor.greenGraphColour()
            break
        
        case .clarity:
            topColor = UIColor.blueGraphColour()
            bottomColor = UIColor.darkPurpleGraphColour()
            break
            
        case .memory:
            topColor = UIColor.purpleGraphColour()
            bottomColor = UIColor.pinkGraphColor()
            break
        }
        
        return ["top":topColor, "bottom":bottomColor]
    }
    
    
    func addLogRecord(logRecord:LogRecord) {
//        logRecords.append(logRecord)
        
        let logRecordDate:NSDate = logRecord.date!
        let dateString = formattedDateString(logRecordDate)
        days.append(dateString)
        
        //moodRatings.append(logRecord.mood!.integerValue)
        
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
        
    }
    
    
    
}


