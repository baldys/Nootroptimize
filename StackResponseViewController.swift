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

 
    enum RatingType {
        case mood
        case energy
        case focus
        case clarity
        case memory
        
    }
    @IBOutlet weak var graphView: GraphView!
    @IBOutlet weak var maxLabel: UILabel!
    
    var currentStack:Stack?
    var logRecords:[LogRecord] = []

    var moodRatings:[Int] = []
    var energyRatings:[Int] = []
    var focusRatings:[Int] = []
    var clarityRatings:[Int] = []
    var memoryRatings:[Int] = []
    
    var daysLogged:[String] = []
    
    var isGraphViewShowing = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backBarButtonItem = navigationItem.leftBarButtonItem
        
        navigationItem.title = currentStack?.name
        

        if let logData:NSSet = (currentStack?.logData)! as NSSet {
            logRecords = logData.allObjects as! [LogRecord]
       
        }

        if (logRecords.count > 0) {
            
            for logRecord in logRecords {
                
                
                
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
                
                
                if let logRecordDate:NSDate = logRecord.date {
                    let dateFormatter = NSDateFormatter()
//                    dateFormatter.dateStyle = .ShortStyle
//                    dateFormatter.timeStyle = .NoStyle
                    dateFormatter.dateFormat = "MMdd"
                    
                    daysLogged.append(dateFormatter.stringFromDate(logRecordDate))
                }
                
                
            }
            graphView.graphPoints = moodRatings

   
        }

        
        

    }

 
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//    @IBAction func showGraphView() {
//        if (isGraphViewShowing) {
//            
//            //hide Graph
//            UIView.transitionFromView(graphView,
//                toView: counterView,
//                duration: 1.0,
//                options: [UIViewAnimationOptions.TransitionFlipFromLeft, UIViewAnimationOptions.ShowHideTransitionViews],
//                completion:nil)
//        } else {
//            
//            //show Graph
//            
//            setupGraphDisplay()
//            
//            UIView.transitionFromView(counterView,
//                toView: graphView,
//                duration: 1.0,
//                options: [UIViewAnimationOptions.TransitionFlipFromRight, UIViewAnimationOptions.ShowHideTransitionViews],
//                completion: nil)
//        }
//        isGraphViewShowing = !isGraphViewShowing
//    }

    func setupGraphDisplay() {
        
        let numberOfDays: Int = daysLogged.count
        
        //1 - replace last day with today's actual data
        
        
        
        
        //2 - indicate that the graph needs to be redrawn
        graphView.setNeedsDisplay()
        
        maxLabel.text = "\(graphView.graphPoints.maxElement()!)"
        
        // #of entries recorded for the stack = graphView.graphPoints
        
        
        
        //set up labels
        //today is last day of the array need to go backwards
        
        //4 - get today's day number
        let dateFormatter = NSDateFormatter()
        
        
//        let calendar = NSCalendar.currentCalendar()
//        let componentOptions:NSCalendarUnit = .Weekday
//        let components = calendar.components(componentOptions,
//            fromDate: NSDate())
//        var weekday = components.weekday

        
        for i in Array((1...daysLogged.count).reverse()) {
            if let labelView = graphView.viewWithTag(i) as? UILabel {
                labelView.text = daysLogged[i]
                
                

            }
        }
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
                //stacks.append(newStack)
            } catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
            
            
            
            graphView.graphPoints.append(mood.integerValue)
            graphView.setNeedsDisplay()
            
            
        }
        
        
        self.dismissViewControllerAnimated(true, completion: nil)


        
        
    }

   
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "addLogRecord") {
            
            if let nc: UINavigationController = segue.destinationViewController as? UINavigationController {
                if let vc: AddLogRecordViewController = nc.viewControllers[0] as? AddLogRecordViewController {
                    
                    vc.delegate = self
                }
            }
        }
        
        
    }


}
