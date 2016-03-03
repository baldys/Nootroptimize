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
    
    var delegate:UpdateCellDelegate?
    
    func setFromRatingCategory(category:RatingCategory) {
        nameLabel.text = category.name
//        valueLabel.text = String(category.value)
        valueLabel.text = "-"
    }
    
    
    @IBAction func changeRating(sender: AnyObject) {
        if sender as! UIStepper == self.stepper {
            
            valueLabel.text = "\(Int(stepper.value))"
        
            self.delegate?.didEditValue(Int(stepper.value), forCell: self)
            
        }
        

    }
    
    
}
