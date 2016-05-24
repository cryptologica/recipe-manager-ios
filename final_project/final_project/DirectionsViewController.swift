//
//  InstructionsViewController.swift
//  final_project
//
//  Created by JT Newsome on 5/2/16.
//  Copyright © 2016 JT Newsome. All rights reserved.
//

import UIKit

protocol RecipeManagerDelegate4: class {
    
    func sendDataToRecipeManager4(sender: DirectionsViewController, recipe: Recipe, index: Int)
}

class DirectionsViewController: UIViewController, DirectionsDelegate {
    
    var directionsText: String?
    
    var recipe: Recipe?
    
    var index: Int?
    
    var sender: RecipeManagerViewController?
    
    weak var delegate: RecipeManagerDelegate4? = nil
    
    private var directionsView: DirectionsView! {
        return (view as! DirectionsView)
    }
    
    override func loadView() {
        view = DirectionsView(frame: CGRectZero)
        
        print("Loaded: DirectionsViewController")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "Directions"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.directionsView.saveButton.addTarget(self, action: #selector(DirectionsViewController.clickedSaveButton), forControlEvents: .TouchUpInside)
    }
    
    // MARK: Receive Data
    // Get data from RecipeManager
    func sendDataToDirectionsViewController(sender: RecipeManagerViewController, recipe: Recipe, index: Int) {
        print("Got data from RecipeManager")
        self.recipe = recipe
        self.index = index
        self.sender = sender
        
        directionsText = ""
        if recipe.rawDirections == "" {
            for (index, str) in recipe.directions!.enumerate() {
                directionsText = directionsText! + "\(index + 1). " + str + "\n\n"
            }
            
            directionsView.directionsBox.text = directionsText!
        }
        else {
            directionsView.directionsBox.text = recipe.rawDirections
        }
    }
    
    func clickedSaveButton() {
        self.recipe?.rawDirections = directionsView.directionsBox.text
        self.delegate = sender
        self.delegate?.sendDataToRecipeManager4(self, recipe: self.recipe!, index: self.index!)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
