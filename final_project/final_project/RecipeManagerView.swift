//
//  RecipeManagerView.swift
//  final_project
//
//  Created by JT Newsome on 4/27/16.
//  Copyright © 2016 JT Newsome. All rights reserved.
//

import UIKit

class RecipeManagerView: UIView {
    
    var conversionFactorTextField: UITextField! // TAG = 1
    var conversionFactorLabel: UILabel!
    var conversionFactorPicker: UIPickerView! // TAG = 3
    var servingsLabel: UILabel!
    var servingsTextField: UITextField! // TAG = 2
    var sysOfMeasureControl: UISegmentedControl!
    var editModeLabel:UILabel!
    var directionsButton: UIButton!
    
    var isMetric: Bool {
        if sysOfMeasureControl.selectedSegmentIndex == 1 {
            return true
        }
        else {
            return false
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.lightGrayColor()
        
        conversionFactorLabel = UILabel(frame: CGRectMake(7, 80, 67, 40))
        conversionFactorLabel.text = "Conversion Factor:"
        conversionFactorLabel.font = UIFont.boldSystemFontOfSize(12)
        conversionFactorLabel.numberOfLines = 2
        conversionFactorLabel.textAlignment = .Center
        conversionFactorLabel.textColor = UIColor.whiteColor()
        addSubview(conversionFactorLabel)
        
        conversionFactorPicker = UIPickerView(frame: CGRectMake(80, 50, 60, 100))
        conversionFactorPicker.tag = 3
        conversionFactorPicker.showsSelectionIndicator = true
        conversionFactorPicker.backgroundColor = UIColor.clearColor()
        conversionFactorPicker.selectRow(3, inComponent: 0, animated: false)
        addSubview(conversionFactorPicker)
        
        conversionFactorTextField = UITextField(frame: CGRectMake(145, 80, 50, 40))
        conversionFactorTextField.tag = 1
        conversionFactorTextField.font = UIFont.systemFontOfSize(15)
        conversionFactorTextField.borderStyle = UITextBorderStyle.RoundedRect
        conversionFactorTextField.autocorrectionType = UITextAutocorrectionType.No
        conversionFactorTextField.keyboardType = UIKeyboardType.DecimalPad
        conversionFactorTextField.returnKeyType = UIReturnKeyType.Done
        conversionFactorTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        addSubview(conversionFactorTextField)
        
        servingsLabel = UILabel(frame: CGRectMake(200, 80, 67, 40))
        servingsLabel.text = "Servings:"
        servingsLabel.font = UIFont.boldSystemFontOfSize(12)
        servingsLabel.textAlignment = .Center
        servingsLabel.textColor = UIColor.whiteColor()
        addSubview(servingsLabel)
        
        servingsTextField = UITextField(frame: CGRectMake(267, 80, 50, 40))
        servingsTextField.tag = 2
        servingsTextField.font = UIFont.systemFontOfSize(15)
        servingsTextField.borderStyle = UITextBorderStyle.RoundedRect
        servingsTextField.autocorrectionType = UITextAutocorrectionType.No
        servingsTextField.keyboardType = UIKeyboardType.DecimalPad
        servingsTextField.returnKeyType = UIReturnKeyType.Done
        servingsTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        addSubview(servingsTextField)
        
        sysOfMeasureControl = UISegmentedControl(frame: CGRectMake(7, 140, 130, 40))
        sysOfMeasureControl.insertSegmentWithTitle("Imperial", atIndex: 0, animated: false)
        sysOfMeasureControl.insertSegmentWithTitle("Metric", atIndex: 1, animated: false)
        sysOfMeasureControl.setWidth(75, forSegmentAtIndex: 0)
        sysOfMeasureControl.setWidth(75, forSegmentAtIndex: 1)
        sysOfMeasureControl.selectedSegmentIndex = 0
        addSubview(sysOfMeasureControl)
        
        editModeLabel = UILabel(frame: CGRectMake(265, 155, 50, 40))
        editModeLabel.userInteractionEnabled = true
        editModeLabel.text = "Edit"
        editModeLabel.font = UIFont.systemFontOfSize(15)
        editModeLabel.textAlignment = .Center
        editModeLabel.textColor = UIColor.blueColor()
        addSubview(editModeLabel)
        
        directionsButton = UIButton(frame: CGRectMake(10, 525, 100, 40))
        directionsButton.setTitle("Directions", forState: .Normal)
        directionsButton.layer.cornerRadius = 6
        directionsButton.backgroundColor = UIColor.whiteColor()
        directionsButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        directionsButton.layer.borderWidth = 1
        addSubview(directionsButton)
        
        let separator: UIView = UIView(frame: CGRectMake(-5, 183.5, 330, 7))
        separator.backgroundColor = UIColor.init(white: 1, alpha: 1)
        separator.layer.borderColor = UIColor.blackColor().CGColor
        separator.layer.borderWidth = 1.5
        addSubview(separator)

        print("Loaded: RecipeManagerView")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
