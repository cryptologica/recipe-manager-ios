//
//  RecipeListView.swift
//  final_project
//
//  Created by JT Newsome on 4/23/16.
//  Copyright © 2016 JT Newsome. All rights reserved.
//

import UIKit

class RecipeListView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.darkGrayColor()
        
        print("Loaded: RecipeListView")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}