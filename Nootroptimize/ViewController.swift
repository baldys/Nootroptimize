//
//  ViewController.swift
//  Nootroptimize
//
//  Created by Veronica Baldys on 2016-01-27.
//  Copyright © 2016 Veronica Baldys. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var stacks = [NSManagedObject]()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addStack(sender: AnyObject) {
        
    
        let alert = UIAlertController(title: "New Name",
            message: "Add a new name",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
            style: .Default,
            handler: { (action:UIAlertAction) -> Void in
                
                
                let textField = alert.textFields!.first
                
                self.saveName(textField!.text!)
                self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
            animated: true,
            completion: nil)
    
    }

    func saveName(name: String) {
        
        let appDelegate = UIApplication .sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Stack", inManagedObjectContext: managedContext)
        
        let stack = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        stack.setValue(name, forKey: "name")
        
        do {
            try managedContext.save()
            stacks.append(stack)
        } catch let error as NSError {
             print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Stack")
        
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            stacks = results as! [NSManagedObject]
            
        /*
            NSFetchRequest is the class responsible for fetching from Core Data. Fetch requests are both powerful and flexible. You can use requests to fetch a set of objects that meet particular criteria (e.g., “give me all employees that live in Wisconsin and have been with the company at least three years”), individual values (e.g., “give me the longest name in the database”) and more.Fetch requests have several qualifiers that refine the set of results they return. For now, you should know that NSEntityDescription is one of these qualifiers (one that is required!).Setting a fetch request’s entity property, or alternatively initializing it with init(entityName:), fetches all objects of a particular entity. This is what you do here to fetch all Person entities.
            */
        } catch let error as NSError {
            print("could not fetch \(error), \(error.userInfo)")
            
        }
            
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Stacks"
        tableView.registerClass(UITableViewCell.self,
            forCellReuseIdentifier: "Cell")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
    return stacks.count
    }
    
    func tableView(tableView: UITableView,
    cellForRowAtIndexPath
    indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell =
    tableView.dequeueReusableCellWithIdentifier("Cell")
    let stack = stacks[indexPath.row]
        
    cell!.textLabel!.text = stack.valueForKey("name") as? String
        
    
    return cell!
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        <#code#>
    }
}

