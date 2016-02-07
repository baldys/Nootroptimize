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
    func addStackViewController(vc: UIViewController, didEnterDataForStackWithName name:String, nootropicsInStack nootropics:NSSet)

    
}

class AddStackViewController: UIViewController, UITextFieldDelegate {

    //var newStack: Stack?
    var delegate: AddStackDelegate?
    var nootropics: NSMutableArray?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
//    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet weak var stackNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Add Stack"
        self.stackNameField.delegate = self
        
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
    func textFieldDidEndEditing(textField: UITextField) {
//        newStack!.name = self.stackNameField.text

        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == stackNameField {
            stackNameField.resignFirstResponder()
            
            
//
//            print("new stack \(self.newStack!.name)")
//
//            do {
//                try newStack!.managedObjectContext!.save()
//
//                
//            } catch let error as NSError {
//            print("Could not save \(error), \(error.userInfo)")
//            }
    
        
            
        }
        return true
    }
    
    @IBAction func save(sender: AnyObject) {
    
//       self.newStack!.name = self.stackNameField.text! as String
        
      
        print ("text field : \(stackNameField.text)")
//        newStack!.name = stackNameField.text
        
        
        
  
//        print("new stack \(self.newStack!.name)")
//        
//        do {
//            try newStack!.managedObjectContext!.save()
//            
//            
//        } catch let error as NSError {
//            print("Could not save \(error), \(error.userInfo)")
//        }
//        
//        
   
        let nootropics:NSSet = NSSet()
        
        
        //self.delegate?.addStackViewController(self, didAddStack: newStack!)
    
        self.delegate?.addStackViewController(self, didEnterDataForStackWithName: stackNameField.text!, nootropicsInStack:nootropics)
        
        
        
    }
    

    @IBAction func cancel(sender: AnyObject) {
    }
   
}
