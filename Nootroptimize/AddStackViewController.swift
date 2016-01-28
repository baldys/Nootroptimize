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
    func addStackViewController(vc: UIViewController, didAddStack stack:Stack)
}

class AddStackViewController: UIViewController, UITextFieldDelegate {

    var newStack: Stack?
    var delegate: AddStackDelegate?
    var nootropics: NSMutableArray?
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet weak var stackNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Add Stack"
        stackNameField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if (textField == self.stackNameField) {
            self.stackNameField.resignFirstResponder()
            self.save(self)
        }
        return true
    }
    
    @IBAction func save(sender: AnyObject) {
    
        newStack = Stack.createInManagedObjectContext(self.managedObjectContext, name: stackNameField.text!)
        
        do {
            try self.managedObjectContext.save()
            //stacks.append(newStack)
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        delegate?.addStackViewController(self, didAddStack:newStack!)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        
    }

}
