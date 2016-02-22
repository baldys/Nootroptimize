//
//  StackResponseViewController.swift
//  Nootroptimize
//
//  Created by Veronica Baldys on 2016-01-28.
//  Copyright © 2016 Veronica Baldys. All rights reserved.
//

// add a point at 0,0 by default so when a point is added to the graph it shows the first point
// then figure out why it shows a different date when you first add a point to the graph

import UIKit
import CoreData

class StackResponseViewController: UIViewController, AddLogRecordDelegate {
    
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
            
            updateGraphWithData(graphData!, forRatingCategory: .mood)
            
        }
    }
    
    func formattedDateString(date:NSDate) -> String {
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.dateStyle = .ShortStyle
//        dateFormatter.dateFormat = "MM-dd"
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
        print("NEW LOG RECORD DATE: \(logRecord.date?.descriptionWithLocale(NSLocale)))")
        
        do {
            try moc!.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        graphData?.addLogRecord(logRecord)

        
        
        
        for i in 0..<graphData!.days.count {
            print("[\(i)]: day: \(graphData!.days[i])")
        }
        

        updateGraphWithData(graphData!, forRatingCategory: ratingTypeFromInt(graphDataControl.selectedSegmentIndex))
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func addLogViewControllerDidCancel() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func ratingTypeFromInt(index:Int) -> GraphData.RatingType {
        let selectedGraphRatingType:GraphData.RatingType = GraphData.RatingType(rawValue: index)!
        return selectedGraphRatingType
    }
    
    // graph points are updated to the most recently added data for a particular rating category
    func updateGraphWithData(data:GraphData, forRatingCategory ratingType:GraphData.RatingType) {
  
     
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
        
//        graphView.xValues = data.days
        
//        graphView.xValues.append(data.days.last!)
        
        
//        var i = 0
//        for day in data.days {
//            i++
//            print(i)
//            print(day)
//        }
//        
        // try to manually append the current day to the xvalues of the graph view.
        



        graphView.yValues = data.getDataForRatingCategory(ratingType)
        graphView.setUpXLabels(data.days)

        let gradientDictionary = data.getColourForRatingCategory(ratingType)
        graphView.topColour = gradientDictionary["top"]!
        graphView.bottomColour = gradientDictionary["bottom"]!
        
        
        //maxLabel.text = "\(graphView.yValues.maxElement()!)"
        maxLabel.text = "10"
        print("last xvalue: \(graphView.xLabels.last!.text)")
        if (graphView.xLabels.count != data.days.count)
        {
            
        }
//        graphView.layoutIfNeeded()
        graphView.setNeedsDisplay()


//        graphView.xValues = daysLogged
//        graphView.graphPoints = newYValues
//        graphView.topColour = startColour
//        graphView.bottomColour = endColour
    
    }
    
    // MARK - Actions
    @IBAction func changeGraphData(sender: UISegmentedControl) {
        updateGraphWithData(graphData!, forRatingCategory: ratingTypeFromInt(sender.selectedSegmentIndex))
    
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
