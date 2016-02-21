//
//  StackResponseViewController.swift
//  Nootroptimize
//
//  Created by Veronica Baldys on 2016-01-28.
//  Copyright © 2016 Veronica Baldys. All rights reserved.
//

import UIKit
import CoreData

class StackResponseViewController: UIViewController, AddLogRecordDelegate {
    
    var selectedGraph:GraphData.RatingType?
    
    @IBOutlet weak var graphView: GraphView!
    @IBOutlet weak var maxLabel: UILabel!
    
    @IBOutlet weak var noStackDataLabel: UILabel!
    
    var currentStack:Stack?
    var logRecords:[LogRecord] = []

    var graphData:GraphData?
    
    @IBOutlet weak var graphDataControl: UISegmentedControl!
    
    var dateFormatter = NSDateFormatter()
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = navigationItem.leftBarButtonItem
        navigationItem.title = currentStack?.name
        prepareStackData()
    }
    
    func prepareStackData() {
        if let logData:NSSet = (currentStack?.logData)! as NSSet {
            let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
            logRecords = logData.sortedArrayUsingDescriptors([sortDescriptor]) as! [LogRecord]
            
            graphData = GraphData(logRecords: logRecords)
            updateGraphWithDataForRatingCategory(.mood)
            // update graph with data(data forRatingCategory:)

        }
        
        ///et stackLog:[Dictionary<String, Int>] = NSSet.mutableOrderedSetValueForKeyPath("date")
        
        // find a more efficient way of doing this....
        
//        if (logRecords.count > 0) {
//            noStackDataLabel.hidden = true
//            for logRecord in logRecords {
//                
//                let logRecordDate:NSDate = logRecord.date!
//                let dateString = formattedDateString(logRecordDate)
//                daysLogged.append(dateString)
//                
//                //moodRatings.append(logRecord.mood!.integerValue)
//
//                if let moodRating:NSNumber = logRecord.mood {
//                    moodRatings.append(moodRating.integerValue)
//                }
//                if let energyRating:NSNumber = logRecord.energy {
//                    energyRatings.append(energyRating.integerValue)
//                }
//                if let focusRating:NSNumber = logRecord.focus {
//                    focusRatings.append(focusRating.integerValue)
//                }
//                if let clarityRating:NSNumber = logRecord.clarity {
//                    clarityRatings.append(clarityRating.integerValue)
//                }
//                if let memoryRating:NSNumber = logRecord.memory {
//                    memoryRatings.append(memoryRating.integerValue)
//                }
//                
//            }
//            //graphView.graphPoints = moodRatings
//            //setupGraphDisplay()
//        }
//        else {
//            noStackDataLabel.hidden = false
//        }

    }
    
    func formattedDateString(date:NSDate) -> String {
        
        dateFormatter.dateFormat = "dd"
        return dateFormatter.stringFromDate(date)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    // MARK: - AddLogRecordDelegate
    
    // here we create a new log record for the current stack based on the ratings entered
    func addLogRecordViewController(viewController:UIViewController, didEnterValuesForMood mood:NSNumber, energy:NSNumber, focus:NSNumber, memory:NSNumber, clarity:NSNumber) {
        
        let moc = currentStack?.managedObjectContext
        
        let logRecord:LogRecord = LogRecord.createInManagedObjectContext((currentStack?.managedObjectContext)!, stack: currentStack!, mood: mood, energy: energy, focus: focus, clarity: clarity, memory: memory, notes: " ")
        
            
        currentStack?.addNewLogRecord(logRecord)

        do {
            try moc!.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
            
            
        graphData?.addLogRecord(logRecord)

        updateGraphWithDataForRatingCategory(ratingTypeFromInt(graphDataControl.selectedSegmentIndex))
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func addLogViewControllerDidCancel() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // graph points are updated to the most recently added data for a particular rating category
    func updateGraphWithDataForRatingCategory(ratingType:GraphData.RatingType) {
  
     
        //        let dateFormatter = NSDateFormatter()
        
        
        //        let calendar = NSCalendar.currentCalendar()
        //        let componentOptions:NSCalendarUnit = .Weekday
        //        let components = calendar.components(componentOptions,
        //            fromDate: NSDate())
        //        var weekday = components.weekday

        if logRecords.count == 0 {
            noStackDataLabel.hidden = false
            return
        }

        // use methods in graph data to get the x values and y values to be supplied to graph view. the graph view will then show these points according to the category  selected
        noStackDataLabel.hidden = true
        graphView.xValues = graphData!.days

        graphView.yValues = graphData!.getDataForRatingCategory(ratingType)
        
        let gradientDictionary = graphData!.getColourForRatingCategory(ratingType)
        graphView.topColour = gradientDictionary["top"]!
        graphView.bottomColour = gradientDictionary["bottom"]!
        
        graphView.setNeedsDisplay()
        
        maxLabel.text = "\(graphView.yValues.maxElement()!)"
        
//        graphView.xValues = daysLogged
//        graphView.graphPoints = newYValues
//        graphView.topColour = startColour
//        graphView.bottomColour = endColour
    
    }
    
    func ratingTypeFromInt(index:Int) -> GraphData.RatingType {
        let selectedGraphRatingType:GraphData.RatingType = GraphData.RatingType(rawValue: index)!
        return selectedGraphRatingType
        //selectedGraph = GraphData.RatingType(rawValue: index)!
        
    }
    
    // MARK - Actions
    @IBAction func changeGraphData(sender: UISegmentedControl) {
        updateGraphWithDataForRatingCategory(ratingTypeFromInt(sender.selectedSegmentIndex))
    
    }
    
  
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "addLogRecord") {
            
            if let nc: UINavigationController = segue.destinationViewController as? UINavigationController {
                if let vc: AddLogRecordViewController = nc.viewControllers[0] as? AddLogRecordViewController {
                    
                    vc.delegate = self
                    vc.stackName = currentStack!.name
                }
            }
        }
    }


}
