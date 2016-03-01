//
//  AddLogRecordViewController.swift
//  Nootroptimize
//
//  Created by Veronica Baldys on 2016-02-07.
//  Copyright © 2016 Veronica Baldys. All rights reserved.
//

import UIKit

protocol AddLogRecordDelegate {
    
    func addLogRecordViewController(viewController:UIViewController, didEnterValuesForMood mood:NSNumber, focus:NSNumber, energy:NSNumber, clarity:NSNumber, memory:NSNumber, forDate date:NSDate)
    func addLogViewControllerDidCancel()
    
}

struct RatingCategory {
    var name:String
    var value:Int
    
    init(name:String, value:Int) {
        self.name = name
        self.value = value
    }
    
    init(name:String) {
        self.name = name
        self.value = 0
    }
}

class AddLogRecordViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UpdateCellDelegate {

    var categories:[RatingCategory] = []
    
    enum ratingCategory {
        case mood
        case energy
        case focus
        case clarity
        case memory
    }
    
    var stackName:String?
    
    @IBOutlet weak var logDatePicker: UIDatePicker!

    // TO DO: use table view; make each row correspond to a rating category, tag each UI element with that row index
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var energyValueLabel: UILabel!
    @IBOutlet weak var focusValueLabel: UILabel!
    @IBOutlet weak var clarityValueLabel: UILabel!
    @IBOutlet weak var memoryValueLabel: UILabel!

    @IBOutlet weak var moodStepper: UIStepper!
    @IBOutlet weak var energyStepper: UIStepper!
    @IBOutlet weak var focusStepper: UIStepper!
    @IBOutlet weak var clarityStepper: UIStepper!
    @IBOutlet weak var memoryStepper: UIStepper!
    
    @IBOutlet weak var notesView: UITextView!
    
    var delegate: AddLogRecordDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = stackName

        logDatePicker.date = NSDate()
        logDatePicker.datePickerMode = .Date
        
        let moodCategory = RatingCategory(name:"Mood")
        let energyCategory = RatingCategory(name:"Energy")
        let focusCategory = RatingCategory(name:"Focus")
        let clarityCategory = RatingCategory(name:"Clarity")
        let memoryCategory = RatingCategory(name:"Memory")
        
        categories = [moodCategory, energyCategory, focusCategory, clarityCategory, memoryCategory]
        
    
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // MARK: - Update Cell Delegate
    
    func didEditValue(value:Int, forCell cell:UITableViewCell) {
        
        let indexPath:NSIndexPath = tableView.indexPathForCell(cell)!
        
        categories[indexPath.row].value = value
        
        
       
    }
    
    // MARK: - Actions
    
    @IBAction func save(sender: AnyObject) {
    
        let selectedDate:NSDate = logDatePicker.date
        var cell:CategoryCell
        
        cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! CategoryCell
        
        delegate?.addLogRecordViewController(self, didEnterValuesForMood: NSNumber(double: moodStepper.value), focus:NSNumber(double: focusStepper.value), energy:NSNumber(double: energyStepper.value),  clarity:NSNumber(double: clarityStepper.value), memory:NSNumber(double: memoryStepper.value), forDate: selectedDate)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        delegate?.addLogViewControllerDidCancel()
    }
    
    // MARK: - table view data source

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellIdentifier = "CategoryCell"
        let cell:CategoryCell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as! CategoryCell
        cell.delegate = self
        let category:RatingCategory = categories[indexPath.row]
        
        cell.setFromRatingCategory(category)
        
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
