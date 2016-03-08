//
//  AddLogRecordViewController.swift
//  Nootroptimize
//
//  Created by Veronica Baldys on 2016-02-07.
//  Copyright © 2016 Veronica Baldys. All rights reserved.
//

import UIKit

protocol AddCategoryDelegate {
    
    func didAddCategory(name:String)
    func didDeleteCategory(name:String)
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

class AddLogRecordViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UpdateCellDelegate,UITextFieldDelegate {

    var categories:[RatingCategory] = []
    let maxNumberOfCategories = 5

    var stack:Stack!
    @IBOutlet weak var logDatePicker: UIDatePicker!

    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: AddCategoryDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = stack.name

        logDatePicker.date = NSDate()
        logDatePicker.datePickerMode = .Date
        
        for categoryName in stack.categoryNames() {
        
            categories.append(RatingCategory(name:categoryName))
            
            print("\(categoryName)")
            
        }

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

    @IBAction func addCategory(sender: AnyObject) {
        
        if categories.count == maxNumberOfCategories {
            print("Exceeds max number of categories")
            // TO DO: Show alert when attempting to add 6th cateory
            return
        }
        let newRatingCategory = RatingCategory(name: "New Category")
        categories.append(newRatingCategory)
        
        // Append new cell
        let newIndexPath = NSIndexPath(forRow: categories.count-1, inSection: 0)
        tableView.beginUpdates()
        tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Automatic)
        tableView.endUpdates()
        
        let newCategoryCell = tableView.cellForRowAtIndexPath(newIndexPath) as! CategoryCell
        newCategoryCell.toggleAddMode(true)
        newCategoryCell.setFromRatingCategory(newRatingCategory)
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
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
    }

    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        let indexPathForAddedCell = NSIndexPath(forRow: categories.count-1, inSection: 0)
        let cell = tableView.cellForRowAtIndexPath(indexPathForAddedCell) as! CategoryCell
        cell.toggleAddMode(false)
        categories[categories.count-1].name = textField.text!
        
        
        
        
        
        
        
        delegate?.didAddCategory(textField.text!)
        
        // TO DO: Delete new categories if cancel is pressed!
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
