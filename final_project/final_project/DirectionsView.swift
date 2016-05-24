//
//  InstructionsView.swift
//  final_project
//
//  Created by JT Newsome on 5/2/16.
//  Copyright © 2016 JT Newsome. All rights reserved.
//

import UIKit

class DirectionsView: UIView {
    
    var directionsBox: UITextView!
    var saveButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.lightGrayColor()
        layer.borderWidth = 1
        layer.borderColor = UIColor.whiteColor().CGColor
        
        directionsBox = UITextView(frame: CGRectMake(10, 80, 300, 300))
        directionsBox.backgroundColor = UIColor.whiteColor()
        directionsBox.textColor = UIColor.blackColor()
        addSubview(directionsBox)
        
        saveButton = UIButton(frame: CGRectMake(10, 400, 300, 50))
        saveButton.setTitle("Save", forState: .Normal)
        saveButton.layer.cornerRadius = 6
        saveButton.backgroundColor = UIColor.whiteColor()
        saveButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        saveButton.layer.borderWidth = 1
        addSubview(saveButton)
        
        print("Loaded: DirectionsView")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
