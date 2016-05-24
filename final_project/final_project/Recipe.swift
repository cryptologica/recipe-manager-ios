//
//  Recipe.swift
//  final_project
//
//  Created by JT Newsome on 4/23/16.
//  Copyright © 2016 JT Newsome. All rights reserved.
//

import Foundation

class Recipe: NSObject, NSCoding {
    
    var title: String?
    var importCode: Int
    var conversionFactor: Float
    var systemOfMeasurement: String?
    var servings: Float
    var originalServings: Float
    var pickerIndex: Int
    
    var rawDirections: String?
    
    var directions: [String]?
    
    var ingredients: [Ingredient]?
    
    var picture: NSData?
    
    init(title: String, importCode: Int) {
        self.title = title
        self.importCode = importCode
        self.conversionFactor = 1.0
        self.systemOfMeasurement = "IMPERIAL"
        self.servings = 0.0
        self.originalServings = 0.0
        self.pickerIndex = 2
        
        self.rawDirections = ""
        
        self.directions = [String]()
        
        self.ingredients = [Ingredient]()
    }
    
    required init(coder decoder: NSCoder) {
        self.title = decoder.decodeObjectForKey("title") as? String
        self.importCode = decoder.decodeIntegerForKey("importCode")
        self.conversionFactor = decoder.decodeFloatForKey("conversionFactor")
        self.systemOfMeasurement = decoder.decodeObjectForKey("systemOfMeasurement") as? String
        self.servings = decoder.decodeFloatForKey("servings")
        self.originalServings = decoder.decodeFloatForKey("originalServings")
        self.pickerIndex = decoder.decodeIntegerForKey("pickerIndex")
        
        self.rawDirections = decoder.decodeObjectForKey("rawDirections") as? String
        
        self.directions = decoder.decodeObjectForKey("directions") as? [String]
        
        self.ingredients = decoder.decodeObjectForKey("ingredients") as? [Ingredient]
        
        self.picture = decoder.decodeObjectForKey("picture") as? NSData
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.title, forKey: "title")
        coder.encodeInteger(self.importCode, forKey: "importCode")
        coder.encodeFloat(self.conversionFactor, forKey: "conversionFactor")
        coder.encodeObject(self.systemOfMeasurement, forKey: "systemOfMeasurement")
        coder.encodeFloat(self.servings, forKey: "servings")
        coder.encodeFloat(self.originalServings, forKey: "originalServings")
        coder.encodeInteger(self.pickerIndex, forKey: "pickerIndex")
        
        coder.encodeObject(self.rawDirections, forKey: "rawDirections")
        
        coder.encodeObject(self.directions, forKey: "directions")
        
        coder.encodeObject(self.ingredients, forKey: "ingredients")
        
        coder.encodeObject(self.picture,forKey: "picture")
    }
    
}