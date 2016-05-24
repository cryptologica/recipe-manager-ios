//
//  DensityDatabaseView.swift
//  final_project
//
//  Created by JT Newsome on 5/2/16.
//  Copyright © 2016 JT Newsome. All rights reserved.
//

import UIKit

class DensityDatabaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.darkGrayColor()
        
        print("Loaded: DensityDatabaseView")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
