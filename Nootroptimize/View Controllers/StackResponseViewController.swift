//
//  StackResponseViewController.swift
//  Nootroptimize
//
//  Created by Veronica Baldys on 2016-01-28.
//  Copyright © 2016 Veronica Baldys. All rights reserved.
//

import UIKit
import CoreData

class StackResponseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddCategoryDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var graphView: GraphView!
    @IBOutlet weak var maxLabel: UILabel!
    
    var stack:Stack!
    var logRecords:[LogRecord] = []

    var graphData:GraphData?
    
    var categories:[String] = []
    @IBOutlet weak var graphDataControl: UISegmentedControl!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = navigationItem.leftBarButtonItem
        navigationItem.title = stack?.name

        categories = stack.categoryNames()
        
    
        // there are 5 segments shown in storyboard, remove them since they aren't consistent with custom categories
        graphDataControl.removeAllSegments()
        for i in 0..<categories.count {
            graphDataControl.insertSegmentWithTitle(categories[i], atIndex: i, animated: false)
        }
        
        graphDataControl.selectedSegmentIndex = 0
        
    
        
        prepareStackData()
    }
    
    func prepareStackData() {
        
//        graphData = GraphData(logRecords: currentStack!.logRecords)
//        graphView.setUpXLabels(graphData!.days)
//        updateGraphWithData(graphData!, forRatingCategory: .mood)
//        
        
        if let logData:NSSet = stack.logData! as NSSet {
            let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
            logRecords = logData.sortedArrayUsingDescriptors([sortDescriptor]) as! [LogRecord]
        
            graphData = GraphData(logRecords: logRecords, stack: stack)
           
            
            categories = stack.categoryNames()

///            graphView.setUpXLabels(graphData!.days)
            
        
        
            //graphView.setUpXLabels(graphData!.getDatesForCategory(categories[0]))
            
            if categories.count > 0 {
                updateGraphWithData(graphData!, forRatingCategory: categories[0])
            }
            
            
            
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    // MARK: - AddLogRecordDelegate
    
//    // here we create a new log record for the current stack based on the ratings entered
//    func addLogRecordViewController(viewController: UIViewController, didEnterValuesForMood mood: NSNumber, focus: NSNumber, energy: NSNumber, clarity: NSNumber, memory: NSNumber, forDate date: NSDate) {
//        
//        let moc = currentStack?.managedObjectContext
//        
//        let logRecord:LogRecord = LogRecord.createInManagedObjectContext((currentStack?.managedObjectContext)!, stack: currentStack!, mood: mood, energy: energy, focus: focus, clarity: clarity, memory: memory, notes: " ")
//        
//        currentStack?.addNewLogRecord(logRecord)
//        print("NEW LOG RECORD DATE: \(logRecord.date?.descriptionWithLocale(NSLocale)))")
//        
//        do {
//            try moc!.save()
//        } catch let error as NSError {
//            print("Could not save \(error), \(error.userInfo)")
//        }
//        
//        graphData?.addLogRecord(logRecord)
//        
//        graphView.addXLabelWithText(graphData!.days.last!)
//        
//        
//        updateGraphWithData(graphData!, forRatingCategory: categories[graphDataControl.selectedSegmentIndex])
//        
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }

//    func addLogViewControllerDidCancel() {
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
    
    func didAddCategory(name:String) {
        // get all graph dates
        stack.addCategoryWithName(name)

        let moc = stack.managedObjectContext!
        

        
        do {
            try moc.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        graphData?.addCategory(name, toStack:stack)
        // add a new segment 
        categories = stack.categoryNames()
        let index:Int = categories.indexOf(name)!
        
        self.graphDataControl.insertSegmentWithTitle(name, atIndex: index, animated: true)
        
        
    }
    
    func didDeleteCategory(name:String) {
        //currentStack.removeCategoryWithName(name)
        self.graphDataControl.removeAllSegments()
        categories = stack.categoryNames()
        for i in 0..<categories.count {
            graphDataControl.insertSegmentWithTitle(categories[i], atIndex: i, animated: false)
        }
        
    }
    
    // graph points are updated to the most recently added data for a particular rating category
    func updateGraphWithData(data:GraphData, forRatingCategory category:String) {
  
        //        let  = NSDateFormatter()
        
        //        let calendar = NSCalendar.currentCalendar()
        //        let componentOptions:NSCalendarUnit = .Weekday
        //        let components = calendar.components(componentOptions,
        //            fromDate: NSDate())
        //        var weekday = components.weekday

        graphView.setUpXLabels(data.getDatesForCategory(category))

        graphView.yValues = data.getRatingValuesForCategory(category)
    
        //graphView.setUpYValues(data.getRatingValuesForCategory(category))

        
        
        
        
        
        let gradientDictionary = data.getColourForRatingCategory(category)
        graphView.topColour = gradientDictionary["top"]!
        graphView.bottomColour = gradientDictionary["bottom"]!
        
        
        if (graphView.yValues.count > 1) {
            var maxValue = graphView.yValues.maxElement()!
            if (maxValue < 1) {
                maxValue = 1
            }
            maxLabel.text = "\(maxValue)"
        }
    
        graphView.setNeedsDisplay()

        graphView.layoutIfNeeded()
    
    }
    
    // MARK - Actions
    @IBAction func changeGraphData(sender: UISegmentedControl) {
        updateGraphWithData(graphData!, forRatingCategory: categories[sender.selectedSegmentIndex])
    
    }
    
    // when rotated in landscape make graph larger
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if size.width > size.height {
            graphView.frame = CGRect(origin:CGPoint(x:0,y:0), size: size)
            
        }
    }

    
    // MARK: - table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stack.nootropicsData.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("NootropicCell", forIndexPath: indexPath)
        
        //let nootropic:Nootropic = nootropics[indexPath.row]
        let nootropic:Nootropic = stack.nootropicsData[indexPath.row]
        
        cell.textLabel?.text = nootropic.name
        cell.detailTextLabel?.text = "\(nootropic.dose!) mg"
    
        return cell
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
        }
        if editingStyle == .Insert {
            
            
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func addLogRecordWithRatings(categoryRatings:[RatingCategory], forDate date:NSDate) {
        

        let logRecord:LogRecord = LogRecord.createInManagedObjectContext(stack.managedObjectContext!, stack: stack!, date:date)


        /////////
        // when adding a log record it automatically creates rating objects from category objects in the stack. 
        // it sets the categoryNames of the ratings to the category objects name, and sets the ratings' value to some default value initially -1)
        // then match each rating from RatingCategories to the name in each rating in the log record and change the values from default to the rating value in the RatingCategory object
        
        
        for categoryRating in categoryRatings {
        
            for rating in logRecord.ratings {
                if (rating.categoryName == categoryRating.name) {
                    //rating.setValue(categoryRating.value, forKey: "value")
                    logRecord.addRating(categoryRating.value, forCategory: categoryRating.name)
                }
            }
        

//            let predicate:NSPredicate = NSPredicate(format: "categoryName == %@", categoryRating.name)
//            let ratingObject:Rating = logRecord.ratings?.filteredSetUsingPredicate(predicate)
//            
//            ratingObject.value = categoryRating.value
            
            
            
            
            
            // rating.categoryName matching categoryRating.name in logRecord
            
            
        }
        
        stack.addNewLogRecord(logRecord)
        let moc = stack.managedObjectContext!

        do {
            try moc.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        categories = stack.categoryNames()

        graphData?.addLogRecord(logRecord)
        
        graphView.addXLabelWithText(graphData!.days.last!)
        
        if (graphDataControl.selectedSegmentIndex == -1) {
            graphDataControl.selectedSegmentIndex = 0
        }
        
        updateGraphWithData(graphData!, forRatingCategory: categories[graphDataControl.selectedSegmentIndex])

    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "addLogRecord") {
            
            if let nc: UINavigationController = segue.destinationViewController as? UINavigationController {
                if let vc: AddLogRecordViewController = nc.viewControllers[0] as? AddLogRecordViewController {
                    
                    vc.delegate = self
                    vc.stack = stack
                }
            }
        }
    }
    
    @IBAction func unwindSegueToStackLog(sender:UIStoryboardSegue) {
        
        if (sender.identifier == "Cancel") {
            return
        }
        let addLogRecordVC = sender.sourceViewController as! AddLogRecordViewController
        let categoryRatings = addLogRecordVC.categories
        let date = addLogRecordVC.logDatePicker.date
        
        addLogRecordWithRatings(categoryRatings, forDate:date)
    }
    
}
