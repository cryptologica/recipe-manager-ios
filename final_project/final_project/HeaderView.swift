//
//  HeaderView.swift
//  final_project
//
//  Created by JT Newsome on 4/23/16.
//  Copyright © 2016 JT Newsome. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    
    // TODO: Change names to 'Footer'
    var imageView: UIImageView?
    var addLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.8, alpha: 0.8)
        addTopBorderWith(UIColor.blackColor(), borderWidth: 1.5)
        
        imageView = UIImageView(frame: CGRectMake(3, 7, 35, 35))
        let image = UIImage(named: "Plus-50.png")
        imageView?.userInteractionEnabled = true
        imageView!.image = image
        addSubview(imageView!)
        
        addLabel = UILabel(frame: CGRectMake(45, 7, 45, 35))
        addLabel?.userInteractionEnabled = true
        addLabel!.text = "Add"
        addLabel!.font = addLabel!.font.fontWithSize(20)
        addSubview(addLabel!)
        
        print("Loaded: HeaderView")
    }
    
    func addTopBorderWith(color: UIColor, borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color;
        border.autoresizingMask = UIViewAutoresizing.FlexibleWidth.exclusiveOr(UIViewAutoresizing.FlexibleBottomMargin)
        border.frame = CGRectMake(0, 0, self.frame.size.width, borderWidth);
        self.addSubview(border)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
