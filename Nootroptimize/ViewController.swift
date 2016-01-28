//
//  ViewController.swift
//  Nootroptimize
//
//  Created by Veronica Baldys on 2016-01-27.
//  Copyright © 2016 Veronica Baldys. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddStackDelegate {
    
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    var stacks = [Stack]()
    
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

    // MARK: AddStackDelegate
    func addStackViewController(vc: UIViewController, didAddStack stack: Stack) {

        self.saveName(stack.name!)
        
        self.dismissViewControllerAnimated(true, completion: nil)
        self.fetchLog()
    }
    
    func saveName(name: String) {
        
        let newStack = Stack.createInManagedObjectContext(self.managedObjectContext, name: name)
        
        self.fetchLog()
        
        if let newItemIndex = stacks.indexOf(newStack) {
            let newLogItemIndexPath = NSIndexPath(forRow: newItemIndex, inSection: 0)
        
            tableView.insertRowsAtIndexPaths([ newLogItemIndexPath ], withRowAnimation: .Automatic)
        }
     
//        let entity = NSEntityDescription.entityForName("Stack", inManagedObjectContext: self.managedObjectContext)
        
//        let stack = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: self.managedObjectContext)
        
        //newStack.setValue(name, forKey: "name")
        
        do {
            try self.managedObjectContext.save()
            //stacks.append(newStack)
        } catch let error as NSError {
             print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    
    func fetchLog() {
        let fetchRequest = NSFetchRequest(entityName: "Stack")
        
        // Create a sort descriptor object that sorts on the "name"
        // property of the Core Data object
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        // Set the list of sort descriptors in the fetch request,
        // so it includes the sort descriptor
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            
            stacks = results as! [Stack]
            
            /*
            NSFetchRequest is the class responsible for fetching from Core Data. Fetch requests are both powerful and flexible. You can use requests to fetch a set of objects that meet particular criteria (e.g., “give me all employees that live in Wisconsin and have been with the company at least three years”), individual values (e.g., “give me the longest name in the database”) and more.Fetch requests have several qualifiers that refine the set of results they return. For now, you should know that NSEntityDescription is one of these qualifiers (one that is required!).Setting a fetch request’s entity property, or alternatively initializing it with init(entityName:), fetches all objects of a particular entity. This is what you do here to fetch all Person entities.
            */
        } catch let error as NSError {
            print("could not fetch \(error), \(error.userInfo)")
            
        }
       
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let fetchRequest = NSFetchRequest(entityName: "Stack")
        
        do {
            let results =
            try self.managedObjectContext.executeFetchRequest(fetchRequest)
            stacks = results as! [Stack]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let testStack = NSEntityDescription.insertNewObjectForEntityForName("Stack", inManagedObjectContext: self.managedObjectContext) as! Stack
        testStack.name = "Test Stack"
        self.title = "My Stacks"
        tableView.registerClass(UITableViewCell.self,
            forCellReuseIdentifier: "Cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
    
        return stacks.count
    }
    
    func tableView(tableView: UITableView,
    cellForRowAtIndexPath
    indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        let stack = stacks[indexPath.row]
        cell!.textLabel!.text = stack.valueForKey("name") as? String
        let dateFormatter = NSDateFormatter()

        cell!.detailTextLabel!.text = dateFormatter.stringFromDate(stack.dateCreated!)
        return cell!
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == .Delete ) {
            
            let stackToDelete = stacks[indexPath.row]
            
            // Delete item from the managedObjectContext
            managedObjectContext.deleteObject(stackToDelete)
            
            self.fetchLog()
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let stack = stacks[indexPath.row]
        performSegueWithIdentifier("showStackData", sender: stack)

        print(stack.name)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "addStack") {
            if let viewController: AddStackViewController = segue.destinationViewController as? AddStackViewController {
                viewController.newStack = Stack.createInManagedObjectContext(self.managedObjectContext, name: "new stack")
                viewController.delegate = self
                
            }
        }
        else if (segue.identifier == "showStackData") {
//            let indexPath = self.tableView.indexPathForSelectedRow
        
        }
    }
}

