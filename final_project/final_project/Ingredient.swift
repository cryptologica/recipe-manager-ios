//
//  Ingredient.swift
//  final_project
//
//  Created by JT Newsome on 4/26/16.
//  Copyright © 2016 JT Newsome. All rights reserved.
//

import Foundation

class Ingredient: NSObject, NSCoding {
    
    var amount: Float {
        willSet {
            amountFrac = decimalToFrac(newValue)
        }
    }
    var amountFrac: String?
    var type: String?
    var name: String?
    var density: Density?
    
    init(amount: Float, amountFrac: String, type: String, name: String) {
        
        self.amount = amount
        self.amountFrac = amountFrac
        self.type = type
        self.name = name
    }
    
    required init(coder decoder: NSCoder) {
        self.amount = decoder.decodeFloatForKey("amount")
        self.amountFrac = decoder.decodeObjectForKey("amountFrac") as? String
        self.type = decoder.decodeObjectForKey("type") as? String
        self.name = decoder.decodeObjectForKey("name") as? String
        self.density = decoder.decodeObjectForKey("density") as? Density
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeFloat(self.amount, forKey: "amount")
        coder.encodeObject(self.amountFrac, forKey: "amountFrac")
        coder.encodeObject(self.type, forKey: "type")
        coder.encodeObject(self.name, forKey: "name")
        coder.encodeObject(self.density, forKey: "density")
    }
    
    func decimalToFrac(number: Float) -> String {
        
        var num: Float = number
        var prepend = ""
        if num > 1 {
            let intNum = Int(num)
            prepend = "\(intNum) "
            num = num - Float(intNum)
            if num == 0.0 {
                return "\(Float(intNum))"
            }
        }
        
        if num == 0.75 {
            return "\(prepend)3/4"
        }
        else if num >= 0.6 && num <= 0.6669 {
            return "\(prepend)2/3"
        }
        else if num == 0.5 {
            return "\(prepend)1/2"
        }
        else if num >= 0.3 && num <= 0.3339 {
            return "\(prepend)1/3"
        }
        else if num == 0.25 {
            return "\(prepend)1/4"
        }
        else if num == 0.125 {
            return "\(prepend)1/8"
        }
        else {
            return "\(Float(number))"
        }
    }

}