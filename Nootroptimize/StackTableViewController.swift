//
//  StackTableViewController.swift
//  Nootroptimize
//
//  Created by Veronica Baldys on 2016-01-27.
//  Copyright © 2016 Veronica Baldys. All rights reserved.
//

import UIKit
import CoreData


class StackTableViewController: UITableViewController, /*UITableViewDataSource, UITableViewDelegate, */ NSFetchedResultsControllerDelegate, AddStackDelegate {
//    
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        self.tableView.rowHeight = 44.0
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("An error occurred")
        }
        //
        //        let testStack = NSEntityDescription.insertNewObjectForEntityForName("Stack", inManagedObjectContext: self.managedObjectContext) as! Stack
        //        testStack.name = "Test Stack"
        self.title = "My Stacks"
        //        tableView.registerClass(UITableViewCell.self,
        //            forCellReuseIdentifier: "Cell")
    }

    
    // MARK: AddStackDelegate
    func addStackViewController(vc: UIViewController, didAddStack stack: Stack) {
        
        //if (stack) {
        //self.performSegueWithIdentifier("showStack", sender: stack)
        //}
        
        if let newStack:Stack = Stack.createInManagedObjectContext(self.managedObjectContext, name: stack.name!) {
        
            
//            let newItemIndex = self.fetchedResultsController.objectAtIndexPath(NSIndexPath(forRow: self.tableView.numberOfRowsInSection(0), inSection: 0))
//            
//        
       
            if let newItemIndexPath:NSIndexPath = NSIndexPath(forRow: self.tableView.numberOfRowsInSection(0), inSection: 0) {
                
                self.tableView.insertRowsAtIndexPaths([ newItemIndexPath], withRowAnimation: .Automatic)
                
            }
            
           
            
            do {
                try self.managedObjectContext.save()
                //stacks.append(newStack)
            } catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
        
            
            
            
        }
       
        
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func add(sender: AnyObject) {
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
        
        // Create a sort descriptor object that sorts on the "name"
        // property of the Core Data object
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        // Set the list of sort descriptors in the fetch request,
        // so it includes the sort descriptor
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            
            ///stacks = results as! [Stack]
            
            /*
            NSFetchRequest is the class responsible for fetching from Core Data. Fetch requests are both powerful and flexible. You can use requests to fetch a set of objects that meet particular criteria (e.g., “give me all employees that live in Wisconsin and have been with the company at least three years”), individual values (e.g., “give me the longest name in the database”) and more.Fetch requests have several qualifiers that refine the set of results they return. For now, you should know that NSEntityDescription is one of these qualifiers (one that is required!).Setting a fetch request’s entity property, or alternatively initializing it with init(entityName:), fetches all objects of a particular entity. This is what you do here to fetch all Person entities.
            */
        } catch let error as NSError {
            print("could not fetch \(error), \(error.userInfo)")
            
        }
       
    }
    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        let fetchRequest = NSFetchRequest(entityName: "Stack")
//        
//        do {
//            let results =
//            try self.managedObjectContext.executeFetchRequest(fetchRequest)
//            stacks = results as! [Stack]
//        } catch let error as NSError {
//            print("Could not fetch \(error), \(error.userInfo)")
//        }
//        
//        
//        
//        do {
//            
//            let results = try self.fetchedResultsController.performFetch()
//            stacks = results as! [Stack]
//            
//        }
//        catch let error as NSError {
//            print("Could not fetch \(error), \(error.userInfo)")
//        }
//
//    }
    
  

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
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let stack = fetchedResultsController.objectAtIndexPath(indexPath) as! Stack
        
        cell.textLabel?.text = stack.name
        let dateFormatter = NSDateFormatter()
        cell.detailTextLabel?.text = dateFormatter.stringFromDate(stack.dateCreated!)
        
        
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "addStack") {
        
            if let nc: UINavigationController = segue.destinationViewController as? UINavigationController {
                if let vc: AddStackViewController = nc.viewControllers[0] as? AddStackViewController {
                    
                    vc.newStack = NSEntityDescription.insertNewObjectForEntityForName("Stack", inManagedObjectContext:self.managedObjectContext) as? Stack
                    //viewController.newStack = Stack.createInManagedObjectContext(self.managedObjectContext, name: "new stack")
                    vc.delegate = self
                    
                }
                
            }
//            if let viewController: AddStackViewController = segue.destinationViewController as? AddStackViewController {
//                
//                
//                viewController.newStack = Stack.createInManagedObjectContext(self.managedObjectContext, name: "new stack")
//                viewController.delegate = self
//                
//            }
        }
        else if (segue.identifier == "showStack") {
            
//            var selectedIndexPath:NSIndexPath = self.tableView.indexPathForSelectedRow!
            
            
            
            
            if let stackResponseVC:StackResponseViewController = segue.destinationViewController as? StackResponseViewController {
                
                stackResponseVC.stack = sender as? Stack
                
                
            }
            
            if ((sender?.isKindOfClass(Stack)) != nil)
            {
                
                
            }
          
            
            
            
            
            
            
            
        }
        
        else if (segue.identifier == "editStack")
        {
            
            
        }
    }
    
    override
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == .Delete ) {
            
//            let stackToDelete = stacks[indexPath.row]
            
            // Delete item from the managedObjectContext
            
            
            
            //managedObjectContext.deleteObject(stackToDelete)
            
            self.fetchLog()
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    
    // MARK: Fetched results controller
    
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        var fetchRequest = NSFetchRequest()
        var entity = NSEntityDescription.entityForName("Stack", inManagedObjectContext: self.managedObjectContext)
        fetchRequest.entity = entity
        //        let primarySortDescriptor = NSSortDescriptor(key: "classification.order", ascending: true)
        //        let secondarySortDescriptor = NSSortDescriptor(key: "commonName", ascending: true)
        //        animalsFetchRequest.sortDescriptors = [primarySortDescriptor, secondarySortDescriptor]
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        
        let frc = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: "Root")
        
        frc.delegate = self
        
        return frc
        
    }()
    
    
    /**
     Delegate methods of NSFetchedResultsController to respond to additions, removals and so on.
     */
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        
        
        switch(type) {
        case .Insert:
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            break;
        case .Delete:
            self.tableView.deleteRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            break;
        case .Update:
            // cast the first argument to your custom UITableViewCell type
            self.configureCell(tableView.cellForRowAtIndexPath(indexPath!)!, atIndexPath:indexPath!)
            break;
        case .Move:
            self.tableView.deleteRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            break;
        }
    }
    
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        
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
    
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        // The fetch controller has sent all current change notifications,
        // so tell the table view to process all updates.
        self.tableView.endUpdates()
    }
    

    override
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    


//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if let sections = fetchedResultsController.sections {
//            let currentSection = sections[section]
//            return currentSection.name
//        }
//        
//        return nil
//    }
    
    
    // MARK: UITableViewDeleoverride gate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedStack = self.fetchedResultsController.objectAtIndexPath(indexPath) as? Stack
        
        
        
        performSegueWithIdentifier("showStack", sender: selectedStack)

        print(selectedStack!.name)
        print(selectedStack?.dateCreated)
        
    }
    

    
    
    
}

