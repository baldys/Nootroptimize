//
//  GraphDataManager.swift
//  Nootroptimize
//
//  Created by Veronica Baldys on 2016-02-19.
//  Copyright © 2016 Veronica Baldys. All rights reserved.
//

import Foundation
import UIKit

let dateFormatter = NSDateFormatter()
func formattedDateString(date:NSDate) -> String {
    
    dateFormatter.dateFormat = "MM-dd"
    return dateFormatter.stringFromDate(date)
    
}



struct DataPoint {
    
    var x:String?
    var y:Int?
    
    init() {
        self.x = " "
        self.y = 0
    }
    
    init(t:NSDate, y:Int) {
        self.x = formattedDateString(t)
        self.y = y
    }
    
    init(y:Int) {
        self.x = formattedDateString(NSDate())
        self.y = y
    }
    
}

class DataModel {
    
    var dataPoints:[DataPoint] = []
    var name:String?
    private var color1:UIColor?
    private var color2:UIColor?
    
    init(name:String, color1:UIColor, color2:UIColor) {
        
        self.dataPoints = [DataPoint()]
        self.name = name
        self.color1 = color1
        self.color2 = color2
    }
    
    init(name:String) {
        self.dataPoints = [DataPoint()]
        self.name = name
        self.color1 = UIColor.aquaGraphColour()
        self.color2 = UIColor.turquoiseGraphColour()
        
    }
    
    func addDataPoint(dataPoint:DataPoint) {
        dataPoints.append(dataPoint)
    }
    
    func addYValue(y:Int) {
        dataPoints.append(DataPoint(y: y))
    }
}


class GraphData {
    
    var dataModel:[DataModel] = []
    
    
    enum RatingType:Int {
        case mood
        case energy
        case focus
        case clarity
        case memory
    }
    
    var dates:[NSDate] = []
    
    var days = [String]()
    // private?

    var mood:[DataPoint] = [DataPoint()]
    var focus:[DataPoint] = [DataPoint()]
    var energy:[DataPoint] = [DataPoint()]
    var clarity:[DataPoint] = [DataPoint()]
    var memory:[DataPoint] = [DataPoint()]
    
    private var moodData:[Int]    = []
    private var focusData:[Int]   = []
    private var energyData:[Int]  = []
    private var clarityData:[Int] = []
    private var memoryData:[Int]  = []

    //var logRecords:[LogRecord] = []
    
    let dateFormatter = NSDateFormatter()
    
    init(logRecords:[LogRecord]) {

//        self.logRecords = logRecords
 
        if (logRecords.count > 0) {
            var i = 0
            
            for logRecord in logRecords {
                addLogRecord(logRecord)
                
                ///
                print("ADDING DATA FROM LOG RECORD # \(String(i)):")
                print("DATE: \(logRecord.date!.description) MOOD RATING: \(String(logRecord.mood))")
                i++
                ///
            }
        }
    }
    
    func addLogRecord(logRecord:LogRecord) {
        //        logRecords.append(logRecord)
        
        let logRecordDate:NSDate = logRecord.date!
        dates.append(logRecordDate)
        
        
        let dateString = formattedDateString(logRecordDate)
        days.append(dateString)
        
        if let moodRating:NSNumber = logRecord.mood {
            moodData.append(moodRating.integerValue)
            
            
            let dataPoint:DataPoint = DataPoint(t:logRecordDate, y:moodRating.integerValue)
            mood.append(dataPoint)


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
    

    
    
    func formattedDateString(date:NSDate) -> String {
            
        dateFormatter.dateFormat = "dd"
        return dateFormatter.stringFromDate(date)
            
    }
    
    func getDataForRatingCategory(ratingType:RatingType) -> [Int] {
        
        switch ratingType {
        case .mood:
            ///
//            print("DATA FOR RATING CATEGORY")
//            for i in 0..<dates.count {
//                print("[\(i+1)] {\(days[i+1])} \(dates[i].descriptionWithLocale(NSLocale)), \(String(moodData[i+1]))")
//            }
            ///
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
    
    

    
    
}


