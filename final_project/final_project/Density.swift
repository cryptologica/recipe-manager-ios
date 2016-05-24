//
//  Density.swift
//  final_project
//
//  Created by JT Newsome on 5/2/16.
//  Copyright © 2016 JT Newsome. All rights reserved.
//

import Foundation

class Density: NSObject, NSCoding {
    
    var density: Int
    var title: String?
    
    init(title: String, density: Int) {
        self.title = title
        self.density = density
    }
    
    required init(coder decoder: NSCoder) {
        self.title = decoder.decodeObjectForKey("title") as? String
        self.density = decoder.decodeIntegerForKey("density")
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.title, forKey: "title")
        coder.encodeInteger(self.density, forKey: "density")
    }
    
}