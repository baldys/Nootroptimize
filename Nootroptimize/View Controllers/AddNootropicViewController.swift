//
//  AddNootropicViewController.swift
//  Nootroptimize
//
//  Created by Veronica Baldys on 2016-02-16.
//  Copyright © 2016 Veronica Baldys. All rights reserved.
//

import UIKit
protocol AddNootropicDelegate {
    
    func addNootropicViewController(vc: UIViewController, didEnterDataForNootropicWithName name:String, dose:NSNumber, doseFrequency:String?)
    
    func addNootropicViewControllerDidCancel()

}

class AddNootropicViewController: UITableViewController, UITextFieldDelegate {


    
    //var nootropic:Nootropic?
    //var stack:Stack?
    //var nootropicData:Dictionary<String,String>?
    var stackName:String?
    var nootropicName:String = " "
    
    var nootropicDose:NSNumber = 0.0     // in mg
    
    
//    var numberOfTimes:Int?
//    var howOften:Int? // daily = 0, weekly = 1
//    
    
    var doseFrequency:String = "1x/day"
    
    var delegate:AddNootropicDelegate?



//    enum NumberOfTimesPer:Int {
//        case day = 0
//        case week = 1
//    }
    

    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var doseField: UITextField!
    
    @IBOutlet weak var frequencyLabel: UILabel!

    @IBOutlet weak var frequencyControl: UISegmentedControl!
    
    // stepper that increments number of times to take a dose
    @IBAction func changeStepperValue(sender: UIStepper) {
        frequencyLabel.text = String(sender.value)
    }
    ///
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "\(stackName)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - UITextField Delegate
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if textField == nameField {
            nootropicName = nameField.text!
        }
        if textField == doseField {
            nootropicDose = numberFromString(doseField.text!)
        }
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        // only allow user to add nootropic unless they have filled in the title
        if !nameField.text!.isEmpty {
            self.navigationItem.rightBarButtonItem?.enabled = true
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // disable saving while editing
        self.navigationItem.rightBarButtonItem?.enabled = false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func numberFromString(string:String) -> NSNumber {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        return formatter.numberFromString(string)!
    }
    
 
    
    @IBAction func save(sender: AnyObject) {
        
        
        delegate?.addNootropicViewController(self, didEnterDataForNootropicWithName: nootropicName, dose: nootropicDose, doseFrequency: doseFrequency)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        delegate?.addNootropicViewControllerDidCancel()
    }
    
    //[stepper setTransform:CGAffineTransformConcat(CGAffineTransformMakeRotation(M_PI_2), CGAffineTransformMakeScale(0.6, 0.6))];


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        
    }


}
