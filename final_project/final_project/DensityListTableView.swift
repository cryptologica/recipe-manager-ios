//
//  DensityListTableView.swift
//  final_project
//
//  Created by JT Newsome on 5/2/16.
//  Copyright © 2016 JT Newsome. All rights reserved.
//

import UIKit

class DensityTableViewCell: UITableViewCell {
    
    var density: Density?
    
    var titleLabel: UILabel!
    var densityLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clearColor()
        
        let height = self.frame.height + 15
        
        titleLabel = UILabel(frame: CGRectMake(7, 7, 200, height * 0.5))
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.numberOfLines = 2
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.textAlignment = .Left
        contentView.addSubview(titleLabel)
        
        densityLabel = UILabel(frame: CGRectMake(207, 7, 60, height * 0.5))
        densityLabel.adjustsFontSizeToFitWidth = true
        densityLabel.textColor = UIColor.blackColor()
        densityLabel.textAlignment = .Left
        contentView.addSubview(densityLabel)
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
