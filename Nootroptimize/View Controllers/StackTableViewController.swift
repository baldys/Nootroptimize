//
//  StackTableViewController.swift
//  Nootroptimize
//
//  Created by Veronica Baldys on 2016-01-27.
//  Copyright © 2016 Veronica Baldys. All rights reserved.
//

import UIKit
import CoreData


class StackTableViewController: UITableViewController,NSFetchedResultsControllerDelegate, AddStackDelegate {

    var managedObjectContext: NSManagedObjectContext!
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        self.tableView.rowHeight = 44.0
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
        //
        
 
        
        //        let testStack = NSEntityDescription.insertNewObjectForEntityForName("Stack", inManagedObjectContext: self.managedObjectContext) as! Stack
        //        testStack.name = "Test Stack"
        self.title = "My Stacks"
        //        tableView.registerClass(UITableViewCell.self,
        //            forCellReuseIdentifier: "Cell")
    }

    
    // MARK: - Add Stack Delegate
    
    // TO DO:
    // use unwind segue instead and just get the stack that was just created from the source vc
    // we are passing a new stack created in prepare for segue to that vc.
    // get mo context from stack and use it to save data
    
    func addStackViewController(vc: UIViewController, didEnterDataForStackWithName name:String, nootropicsInStack nootropics:NSSet) {
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        
        let newStack:Stack = fetchedResultsController.objectAtIndexPath(indexPath) as! Stack
        
        
        newStack.name = name
        newStack.nootropics = nootropics
        newStack.dateCreated = NSDate()
        
        
//        Stack.createInManagedObjectContext(self.managedObjectContext, name: name)
        
        
        do {
                //try newStack.managedObjectContext!.save()
                try self.managedObjectContext.save()
                //stacks.append(newStack)
        } catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
        }

        self.dismissViewControllerAnimated(true, completion: nil)
        // put into completion handler above
//        let newItemIndex = self.fetchedResultsController.fetchedObjects?.count -1
//        let indexPath = NSIndexPath(forRow: newItemIndex!, inSection: 0)
//        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
        self.tableView.reloadData()
    }
    
    func addStackViewControllerDidCancel() {
        self.dismissViewControllerAnimated(true, completion: nil)

    }


  /*
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
    
    */
    func fetchLog() {
        let fetchRequest = NSFetchRequest(entityName: "Stack")
 
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
      
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            
            ///stacks = results as! [Stack]
            
                  } catch let error as NSError {
            print("could not fetch \(error), \(error.userInfo)")
            
        }
       
    }
  
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

 
    
    // MARK: TableView Data Source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        return 0
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        if let sections = fetchedResultsController.sections {
            
            let currentSection = sections[section]
           
            numberOfRows = currentSection.numberOfObjects
        }
        
        return numberOfRows
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("StackCell", forIndexPath: indexPath)
        
//        let stack = fetchedResultsController.objectAtIndexPath(indexPath) as! Stack
        
//        cell.textLabel?.text = stack.name
//        let dateFormatter = NSDateFormatter()
//        
//        dateFormatter.timeStyle = .NoStyle
//        dateFormatter.dateStyle = .ShortStyle
//        
//        if stack.dateCreated != nil {
//            cell.detailTextLabel?.text = dateFormatter.stringFromDate(stack.dateCreated!)
//        }
        configureCell(cell, atIndexPath: indexPath)
        
        
        return cell
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        
        if let stack:Stack = fetchedResultsController.objectAtIndexPath(indexPath) as? Stack {
            
            cell.textLabel?.text = stack.name
            let dateFormatter = NSDateFormatter()
            dateFormatter.timeStyle = .NoStyle
            dateFormatter.dateStyle = .ShortStyle
            
            if stack.dateCreated != nil {
                cell.detailTextLabel?.text = dateFormatter.stringFromDate(stack.dateCreated!)
            }
        }

        

    }
    
    // MARK: UITableViewDelegate override
    
    override
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(editingStyle == .Delete ) {
            
            let stackToDelete = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Stack
            
            managedObjectContext.deleteObject(stackToDelete)
            
//            tableView.reloadData()
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    override
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "addStack") {
        
            if let nc: UINavigationController = segue.destinationViewController as? UINavigationController {
                if let vc: AddStackViewController = nc.viewControllers[0] as? AddStackViewController {

                    vc.delegate = self
                    
                    
                    
                    
                    
                    vc.stack =  NSEntityDescription.insertNewObjectForEntityForName("Stack", inManagedObjectContext: self.managedObjectContext) as? Stack
                    
                    
                    
                    
                    
                }
                
            }
        }
        else if (segue.identifier == "showStack") {
            
            if let nc: UINavigationController = segue.destinationViewController as? UINavigationController {
                
            
                if let stackResponseVC:StackResponseViewController = nc.viewControllers[0] as? StackResponseViewController {
                
                
               
                    let selectedIndexPath = self.tableView.indexPathForSelectedRow!
                
               
                    let selectedStack:Stack = self.fetchedResultsController.objectAtIndexPath(selectedIndexPath) as! Stack
                
               
                    stackResponseVC.currentStack = selectedStack

                }
                
            }
            
        }
    }
    

    
    // MARK: - Fetched results controller
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Stack")

        let sortDescriptor = NSSortDescriptor(key: "dateCreated", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Root")
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
        
    }()
    
    
    // MARK: - Fetched Results Controller Delegate
    
    /**
     Delegate methods of NSFetchedResultsController to respond to additions, removals and so on.
     */
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
        // tableView.beginUpdates()
    }
//
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        
        
        switch type {
//        case .Insert:
//            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
//            break
        case .Delete:
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            break
//        case .Update:
//            // cast the first argument to your custom UITableViewCell type
//            self.configureCell(tableView.cellForRowAtIndexPath(indexPath!)!, atIndexPath:indexPath!)
//            break
        
        default:
            self.tableView.reloadData()
            break
            
//        case .Move:
//            self.tableView.deleteRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
//            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
//            break
        }
    }
    
   
    
    /// swift
    //    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
    //        switch(type) {
    //            case .Insert:
    //
    //                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
    //                break;
    //
    //            case .Delete:
    //                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
    //                break;
    //    }
    
    /// obj c
    //    - (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    //
    //    switch(type) {
    //    case NSFetchedResultsChangeInsert:
    //    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
    //    break;
    //
    //    case NSFetchedResultsChangeDelete:
    //    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
    //    break;
    //
    //    }
    
//    
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        // The fetch controller has sent all current change notifications,
        // so tell the table view to process all updates.
        
//        self.tableView.endUpdates()
    }
    


    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        

    }
    
    @IBAction func unwindToStacks(segue:UIStoryboardSegue) {
        
    }
    
 

}
