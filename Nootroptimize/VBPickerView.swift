//
//  VBPickerView.swift
//  Nootroptimize
//
//  Created by Veronica Baldys on 2016-02-16.
//  Copyright © 2016 Veronica Baldys. All rights reserved.
//
// reusable class for displaying a static picker view

import UIKit

class VBPickerView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    var dataSource = [String]()
    
    var pickerView:UIPickerView?
  
    
//    - (void)viewDidLoad {
//    [super viewDidLoad];
//    _myArray = @[@"Row 1", @"Row 2", @"Row 3",];
//    }
    
    
    func setUpPickerViewWithDataSource(dataSource:[String]) {
        pickerView?.delegate = self
        pickerView?.dataSource = self
        self.dataSource = dataSource
        
        
    }

    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
        
    }
    
    // tell the picker how many components it will have
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return dataSource.count
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Handle the selection

    }
    
    // tell the picker the width of each row for a given component
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.width
    }

}
