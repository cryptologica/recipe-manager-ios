//
//  AddIngredientView.swift
//  final_project
//
//  Created by JT Newsome on 4/24/16.
//  Copyright © 2016 JT Newsome. All rights reserved.
//

import UIKit

class AddIngredientView: UIView {
    
    var amountField: UITextField!
    var typePicker: UIPickerView!
    var descriptionField: UITextField!
    var saveButton: UIButton!
    var cancelButton: UIButton!
    var deleteButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.lightGrayColor()
        layer.borderWidth = 1
        layer.borderColor = UIColor.whiteColor().CGColor
        
        amountField = UITextField(frame: CGRectMake(10, 80, 300, 50))
        amountField.placeholder = "Quantity"
        amountField.backgroundColor = UIColor.whiteColor()
        amountField.borderStyle = UITextBorderStyle.RoundedRect
        amountField.keyboardType = .DecimalPad
        addSubview(amountField)
        
        typePicker = UIPickerView(frame: CGRectMake(75, 160, 150, 100));
        typePicker.showsSelectionIndicator = true
        typePicker.backgroundColor = UIColor.whiteColor()
        addSubview(typePicker)
        
        descriptionField = UITextField(frame: CGRectMake(10, 290, 300, 50))
        descriptionField.placeholder = "Cooking Item Description"
        descriptionField.borderStyle = UITextBorderStyle.RoundedRect
        addSubview(descriptionField)
        
        saveButton = UIButton(frame: CGRectMake(10, 360, 140, 50))
        saveButton.setTitle("Save", forState: .Normal)
        saveButton.layer.cornerRadius = 6
        saveButton.backgroundColor = UIColor.whiteColor()
        saveButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        saveButton.layer.borderWidth = 1
        addSubview(saveButton)
        
        cancelButton = UIButton(frame: CGRectMake(170, 360, 140, 50))
        cancelButton.setTitle("Cancel", forState: .Normal)
        cancelButton.layer.cornerRadius = 6
        cancelButton.backgroundColor = UIColor.whiteColor()
        cancelButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        cancelButton.layer.borderWidth = 1
        addSubview(cancelButton)
        
        deleteButton = UIButton(frame: CGRectZero)
        deleteButton.setTitle("Delete", forState: .Normal)
        deleteButton.layer.cornerRadius = 6
        deleteButton.backgroundColor = UIColor.whiteColor()
        deleteButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        deleteButton.layer.borderWidth = 1
        addSubview(deleteButton)
        
        print("Loaded: AddIngredientView")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
