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

 
    enum RatingType:Int {
        case mood, energy, focus, clarity, memory
    }
    
    
    
    @IBOutlet weak var graphView: GraphView!
    @IBOutlet weak var maxLabel: UILabel!
    
    @IBOutlet weak var noStackDataLabel: UILabel!
    
    var currentStack:Stack?
    var logRecords:[LogRecord] = []

    var moodRatings:[Int] = []
    var energyRatings:[Int] = []
    var focusRatings:[Int] = []
    var clarityRatings:[Int] = []
    var memoryRatings:[Int] = []
    
    var daysLogged:[String] = []
    
    @IBOutlet weak var graphDataControl: UISegmentedControl!
//    var isGraphViewShowing = false
    
    var dateFormatter = NSDateFormatter()
    
//    var xLabels:[UILabel] = []
    
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
        }
        
        
        if (logRecords.count > 0) {
            
            for logRecord in logRecords {
                
                let logRecordDate:NSDate = logRecord.date!
                let dateString = formattedDateString(logRecordDate)
                daysLogged.append(dateString)
                
                //moodRatings.append(logRecord.mood!.integerValue)

                if let moodRating:NSNumber = logRecord.mood {
                    moodRatings.append(moodRating.integerValue)
                }
                if let energyRating:NSNumber = logRecord.energy {
                    energyRatings.append(energyRating.integerValue)
                }
                if let focusRating:NSNumber = logRecord.focus {
                    focusRatings.append(focusRating.integerValue)
                }
                if let clarityRating:NSNumber = logRecord.clarity {
                    clarityRatings.append(clarityRating.integerValue)
                }
                if let memoryRating:NSNumber = logRecord.memory {
                    memoryRatings.append(memoryRating.integerValue)
                }
                
            }
            graphView.graphPoints = moodRatings
            setupGraphDisplay()
        }
        else {
            noStackDataLabel.hidden = false
        }

    }
    
    func formattedDateString(date:NSDate) -> String {
        
        dateFormatter.dateFormat = "dd"
        return dateFormatter.stringFromDate(date)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    func setUpGraphDisplayWithYValues(yValues:Array<Int>, withStartColour colour1:UIColor, andEndColour colour2:UIColor) {
        
        graphView.xValues = daysLogged
        graphView.graphPoints = yValues
        graphView.startColor = colour1
        graphView.endColor = colour2
    
        // graph needs to be redrawn
        graphView.setNeedsDisplay()
        
        maxLabel.text = "\(graphView.graphPoints.maxElement()!)"
    }
    
    
    func setupGraphDisplay() {
     
        graphView.xValues = daysLogged

        //2 - indicate that the graph needs to be redrawn
        graphView.setNeedsDisplay()
    
        maxLabel.text = "\(graphView.graphPoints.maxElement()!)"
        
        //4 - get today's day number
//        let dateFormatter = NSDateFormatter()
        
        
//        let calendar = NSCalendar.currentCalendar()
//        let componentOptions:NSCalendarUnit = .Weekday
//        let components = calendar.components(componentOptions,
//            fromDate: NSDate())
//        var weekday = components.weekday

        
    }

    // MARK: - AddLogRecordDelegate
    
    // here we create a new log record for the current stack based on the ratings entered
    func addLogRecordViewController(viewController:UIViewController, didEnterValuesForMood mood:NSNumber, energy:NSNumber, focus:NSNumber, memory:NSNumber, clarity:NSNumber) {
        
        let moc = currentStack?.managedObjectContext
        
        if let logRecord:LogRecord = LogRecord.createInManagedObjectContext((currentStack?.managedObjectContext)!, stack: currentStack!, mood: mood, energy: energy, focus: focus, clarity: clarity, memory: memory, notes: " ") {
            
            currentStack?.addNewLogRecord(logRecord)

            do {
                //try newStack.managedObjectContext!.save()
                try moc!.save()
            } catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
            
            
            let dateString = formattedDateString(logRecord.date!)
            daysLogged.append(dateString)
            
            
            //graphView.graphPoints.append(mood.integerValue)
            moodRatings.append(mood.integerValue)
            energyRatings.append(energy.integerValue)
            focusRatings.append(focus.integerValue)
            clarityRatings.append(clarity.integerValue)
            memoryRatings.append(memory.integerValue)
            //mood, energy, focus, clarity, memory

//            setUpGraphDisplayWithYValues(<#T##yValues: Array<Int>##Array<Int>#>, withStartColour: <#T##UIColor#>, andEndColour: <#T##UIColor#>)
            
            
            graphView.setNeedsDisplay()
        
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func addLogViewControllerDidCancel() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK - Actions
    @IBAction func changeGraphData(sender: UISegmentedControl) {

        let selectedGraphRatingType:RatingType = RatingType(rawValue: sender.selectedSegmentIndex)!
        var newYValues:[Int]
        var startColour:UIColor
        var endColour:UIColor
       
        switch selectedGraphRatingType {
        case .mood:
            newYValues = moodRatings
            // red
            startColour = UIColor(colorLiteralRed:250/255, green:63/255, blue:32/255, alpha:1)
            // yellow
            endColour = UIColor(colorLiteralRed:1, green:232/255, blue:0, alpha:1)
            //graphView.graphPoints = moodRatings
            break
            
        case .energy:
            newYValues = energyRatings
            // aqua
            startColour = UIColor(colorLiteralRed:0, green:250/255, blue:199/255, alpha:1)
            // turquoise
            endColour = UIColor(colorLiteralRed:23/255, green:186/255, blue:250/255, alpha:1)
            //graphView.graphPoints = focusRatings
            break
            
        case .focus:
            newYValues = focusRatings
            // yellow
            startColour = UIColor.yellowColor()
            // green
            endColour = UIColor(colorLiteralRed:19/255, green:220/255, blue:0, alpha:1)

            //graphView.graphPoints = energyRatings
            break
            

            
        case .clarity:
            newYValues = clarityRatings
            // blue
            startColour = UIColor(colorLiteralRed:0, green:175/255, blue:1, alpha:1)
            // dark purple
            endColour = UIColor(colorLiteralRed:65/255, green:5/255, blue:220/255, alpha:1)
            //graphView.graphPoints = clarityRatings
            break
            
        case .memory:
            newYValues = memoryRatings
            // purple
            startColour = UIColor(colorLiteralRed:118/255, green:58/255, blue:242/255, alpha:1)
            // pink
            endColour = UIColor(colorLiteralRed:250/255, green:73/255, blue:233/255, alpha:1)
            //graphView.graphPoints = memoryRatings
            break
        }
        
        setUpGraphDisplayWithYValues(newYValues, withStartColour: startColour, andEndColour: endColour)
        
        
        //setupGraphDisplay()
    }
    
    func updateGraphData() {
        
        
        
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
