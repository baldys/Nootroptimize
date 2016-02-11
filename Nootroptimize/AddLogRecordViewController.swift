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
    
    
    
}

class AddLogRecordViewController: UIViewController {

    
    @IBOutlet weak var moodValueLabel: UILabel!
    
    
    @IBOutlet weak var energyStepper: UIStepper!
    @IBOutlet weak var moodStepper: UIStepper!
    
    var delegate: AddLogRecordDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

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
        
    }
    
    @IBAction func save(sender: AnyObject) {
       
        
        
        delegate?.addLogRecordViewController(self, didEnterValuesForMood: NSNumber(double: moodStepper.value), energy:0, focus:0, memory:0, clarity:0)
        
        
        
        
    }
    
    @IBAction func cancel(sender: AnyObject) {
        
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
