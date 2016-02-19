//
//  AddLogRecordViewController.swift
//  Nootroptimize
//
//  Created by Veronica Baldys on 2016-02-07.
//  Copyright © 2016 Veronica Baldys. All rights reserved.
//

import UIKit

protocol AddLogRecordDelegate {
    
    func addLogRecordViewController(viewController:UIViewController, didEnterValuesForMood mood:NSNumber, energy:NSNumber, focus:NSNumber, memory:NSNumber, clarity:NSNumber)
    
    func addLogViewControllerDidCancel()
    
}

class AddLogRecordViewController: UIViewController {

    enum ratingCategory {
        case mood
        case energy
        case focus
        case clarity
        case memory
    }
    
    var stackName:String?
    
    @IBOutlet weak var stackNameLabel: UILabel!
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
    
    
    var delegate: AddLogRecordDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.stackNameLabel.text = stackName

        logDatePicker.date = NSDate()
        logDatePicker.datePickerMode = .Date
        logDatePicker.maximumDate = NSDate()
        
        /* obj c:
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        [dateComponents setMonth:1];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:originalDate options:0]; */
        
//        let ti = 3600*152*
//        let yearStartDate = NSDate.dateByAddingTimeInterval(<#T##NSDate#>)
//        
//        
//        logDatePicker.miniumumDate =
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeStepperValue(sender: UIStepper) {
        
        if sender == moodStepper {
            moodValueLabel.text = String(moodStepper.value)
        }
        if sender == energyStepper {
            energyValueLabel.text = String(energyStepper.value)
        }
        if sender == focusStepper {
            focusValueLabel.text = String(focusStepper.value)
        }
        if sender == clarityStepper {
            clarityValueLabel.text = String(clarityStepper.value)
        }
        if sender == memoryStepper {
            memoryValueLabel.text = String(memoryStepper.value)
        }
        
    }
    
    @IBAction func changeLogDate(sender: UIDatePicker) {
        
        
    }
    
    @IBAction func save(sender: AnyObject) {
    
        if logDatePicker.date != NSDate() {
            
            
        }
        
        delegate?.addLogRecordViewController(self, didEnterValuesForMood: NSNumber(double: moodStepper.value), energy:NSNumber(double: energyStepper.value), focus:NSNumber(double: focusStepper.value), memory:NSNumber(double: memoryStepper.value), clarity:NSNumber(double: clarityStepper.value))
        
        
        
        
        
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
