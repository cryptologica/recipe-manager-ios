//
//  IngredientListTableView.swift
//  final_project
//
//  Created by JT Newsome on 4/29/16.
//  Copyright © 2016 JT Newsome. All rights reserved.
//

import UIKit

class IngredientListTableView: UITableViewCell {
    
    var ingredient: Ingredient?
    
    var amountLabel: UILabel!
    var typeLabel: UILabel!
    var titleLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clearColor()
        
        amountLabel = UILabel(frame: CGRectMake(7, 7, 30, 30))
        amountLabel.textColor = UIColor.blackColor()
        amountLabel.textAlignment = .Left
        amountLabel.adjustsFontSizeToFitWidth = true
        contentView.addSubview(amountLabel)
        
        typeLabel = UILabel(frame: CGRectMake(37, 7, 80, 30))
        typeLabel.textColor = UIColor.blackColor()
        typeLabel.textAlignment = .Left
        typeLabel.adjustsFontSizeToFitWidth = true
        contentView.addSubview(typeLabel)
        
        titleLabel = UILabel(frame: CGRectMake(117, 7, 185, 30))
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.textAlignment = .Left
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.numberOfLines = 2
        contentView.addSubview(titleLabel)
    }
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame = newFrame
            // inset => distance away from edge of screen for each cell
            let inset: CGFloat = 10
            frame.origin.x += inset
            frame.size.width -= inset * 2
            super.frame = frame
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

