//
//  AddStackViewController.swift
//  Nootroptimize
//
//  Created by Veronica Baldys on 2016-01-27.
//  Copyright © 2016 Veronica Baldys. All rights reserved.
//

import UIKit
import CoreData

protocol AddStackDelegate {
    func addStackViewController(vc: UIViewController, didEnterDataForStackWithName name:String, nootropicsInStack nootropics:NSSet)

    func addStackViewControllerDidCancel()
    
    
}

class AddStackViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, AddNootropicDelegate {

    //var newStack: Stack?
    var delegate: AddStackDelegate?
    var nootropics = [Nootropic]()
    var stack:Stack?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var stackNameField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Add Stack"
        stackNameField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Table View Delegate

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nootropics.count
    
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
        
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("NootropicCell", forIndexPath: indexPath)
      
        let nootropic:Nootropic = nootropics[indexPath.row]
        
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
    
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "addNootropic") {
            
            if let nc: UINavigationController = segue.destinationViewController as? UINavigationController {
                if let vc: AddNootropicViewController = nc.viewControllers[0] as? AddNootropicViewController {
                    
                    
                    vc.delegate = self
                    vc.stackName = stack?.name
                }
            }
        }
    }
    
    // MARK: - TextField Delegate

    func textFieldDidEndEditing(textField: UITextField) {
//        newStack!.name = self.stackNameField.text

        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == stackNameField {
            stackNameField.resignFirstResponder()
        }
        return true
    }
    
    
    
    @IBAction func save(sender: AnyObject) {
  
        print ("text field : \(stackNameField.text)")

        let nootropicStack = NSSet(array: nootropics)
        
        
        self.delegate?.addStackViewController(self, didEnterDataForStackWithName: stackNameField.text!, nootropicsInStack:nootropicStack)
     
    }
    

    @IBAction func cancel(sender: AnyObject) {
        self.delegate?.addStackViewControllerDidCancel()
        
    }
    
//    @IBAction func unwindToAddStack(segue: UIStoryboardSegue) {
//    
//        let vc = segue.sourceViewController as? AddNootropicViewController
//        
//        
//        
//        if let nootropic:Nootropic = vc?.nootropic {
//            // add nootropic to array
//            insertNewObject(nootropic)
//        }
//        
//        
// 
//    }
    
    // MARK: - AddNootropicDelegate
    
    func addNootropicViewController(vc: UIViewController, didEnterDataForNootropicWithName name: String, dose: NSNumber, doseFrequency: String?) {
        
        let moc = stack?.managedObjectContext
        
        if let nootropic:Nootropic = Nootropic.createInManagedObjectContext(stack!.managedObjectContext!, stack: stack!, name: name, dose: dose, frequency: doseFrequency!) {
            
            stack?.addNootropic(nootropic)

            do {
                //try newStack.managedObjectContext!.save()
                try moc!.save()
            } catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
            
            insertNewObject(nootropic)
            
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addNootropicViewControllerDidCancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
   
    func insertNewObject(item: AnyObject) {
        let nootropic = item as! Nootropic
        nootropics.insert(nootropic, atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
}
