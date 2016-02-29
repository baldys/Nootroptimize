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

class AddLogRecordViewController: UITableViewController {

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
    
    @IBOutlet weak var moodValueLabel: UILabel!
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
        //logDatePicker.maximumDate = NSDate()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func changeStepperValue(sender: UIStepper) {
        
        if sender == moodStepper {
            moodValueLabel.text = "\(Int(moodStepper.value))"
        }
        if sender == energyStepper {
            energyValueLabel.text = "\(Int(energyStepper.value))"
        }
        if sender == focusStepper {
            focusValueLabel.text = "\(Int(focusStepper.value))"
        }
        if sender == clarityStepper {
            clarityValueLabel.text = "\(Int(clarityStepper.value))"
        }
        if sender == memoryStepper {
            memoryValueLabel.text = "\(Int(memoryStepper.value))"
        }
        
    }
    
    
    @IBAction func save(sender: AnyObject) {
    
        let selectedDate:NSDate = logDatePicker.date
        
        delegate?.addLogRecordViewController(self, didEnterValuesForMood: NSNumber(double: moodStepper.value), focus:NSNumber(double: focusStepper.value), energy:NSNumber(double: energyStepper.value),  clarity:NSNumber(double: clarityStepper.value), memory:NSNumber(double: memoryStepper.value), forDate: selectedDate)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        delegate?.addLogViewControllerDidCancel()
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
