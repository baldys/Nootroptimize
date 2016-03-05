//
//  CategoryCell.swift
//  Nootroptimize
//
//  Created by Veronica Baldys on 2016-02-29.
//  Copyright © 2016 Veronica Baldys. All rights reserved.
//

import UIKit
protocol UpdateCellDelegate {
    
    func didEditValue(value:Int, forCell cell:UITableViewCell)
    
}

class CategoryCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    @IBOutlet weak var categoryTextField: UITextField!

    
    var delegate:UpdateCellDelegate?
    // When adding a new item, replace name label with text field, hide value labels and stepper and when done editing return to normal state
    var addMode:Bool = false
    
    
    func setFromRatingCategory(category:RatingCategory) {
        
        if addMode {
            categoryTextField.text = category.name
        }
        else{
            nameLabel.text = category.name
            //        valueLabel.text = String(category.value)
            valueLabel.text = "-"
        }

    }
    
    func toggleAddMode(addMode:Bool) {
        self.addMode = addMode
        nameLabel.hidden = addMode
        valueLabel.hidden = addMode
        stepper.hidden = addMode
        categoryTextField.hidden = !addMode

        if !addMode {
            nameLabel.text = categoryTextField.text
        }
    }
    
    @IBAction func changeRating(sender: AnyObject) {
        if sender as! UIStepper == self.stepper {
            
            valueLabel.text = "\(Int(stepper.value))"
        
            self.delegate?.didEditValue(Int(stepper.value), forCell: self)
            
        }
        

    }

    
}
