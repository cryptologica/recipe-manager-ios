//
//  AddRecipeViewController.swift
//  final_project
//
//  Created by JT Newsome on 5/2/16.
//  Copyright © 2016 JT Newsome. All rights reserved.
//

import UIKit

protocol RecipeManagerDelegate2: class {
    
    func sendDataToRecipeManager2(sender: AddIngredientViewController, ingredient: Ingredient, index: Int)
}

class AddIngredientViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, AddIngredientDelegate {
    
    weak var delegate: RecipeManagerDelegate2? = nil
    
    var validAmount = false
    
    var validDescription = false
    
    var measurementTypesList: [String] = ["pound", "ounce", "gallon", "pint", "quart", "cup", "pinch", "count", "tablespoon", "teaspoon", "mililiter", "liter", "gram", "kilogram", "fl. ounce", "jigger"]
    
    var sender: RecipeManagerViewController?
    
    var ingredient: Ingredient?
    
    var index: Int?
    
    var pickerIndex: Int = 7
    
    var isEdit: Bool = false
    
    private var addIngredientView: AddIngredientView! {
        return (view as! AddIngredientView)
    }
    
    override func loadView() {
        view = AddIngredientView(frame: CGRectZero)
        
        print("Loaded: AddIngredientViewController")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "Add Ingredient"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        self.addIngredientView.typePicker.delegate = self
        self.addIngredientView.typePicker.dataSource = self
        self.addIngredientView.typePicker.selectRow(7, inComponent: 0, animated: false)
        
        self.addIngredientView.amountField.addTarget(self, action: #selector(AddIngredientViewController.textChangedAmount), forControlEvents: .EditingChanged)
        self.addIngredientView.descriptionField.addTarget(self, action: #selector(AddIngredientViewController.textChangedDescription), forControlEvents: .EditingChanged)
        
        self.addIngredientView.saveButton.addTarget(self, action: #selector(AddIngredientViewController.clickedSaveButton), forControlEvents: .TouchUpInside)
        self.addIngredientView.cancelButton.addTarget(self, action: #selector(AddIngredientViewController.clickedCancelButton), forControlEvents: .TouchUpInside)
        self.addIngredientView.deleteButton.addTarget(self, action: #selector(AddIngredientViewController.clickedDeleteButton), forControlEvents: .TouchUpInside)
    }
    
    // MARK: Receive Data
    func sendDataToAddIngredientViewController(sender: RecipeManagerViewController, ingredient: Ingredient?, index: Int, isEdit: Bool) {
        print("Received Data from RecipeManager")
        self.isEdit = isEdit
        self.index = index
        self.sender = sender
        if isEdit == true {
            self.title = "Edit Ingredient"
            self.ingredient = ingredient
            
            self.addIngredientView.amountField.text = ingredient?.amount.description
            self.addIngredientView.typePicker.selectRow(sender.findMeasurementIndex((ingredient?.type)!), inComponent: 0, animated: false)
            self.addIngredientView.descriptionField.text = ingredient?.name!
            
            self.addIngredientView.saveButton.frame = CGRectMake(10, 360, 300, 50)
            self.addIngredientView.deleteButton.frame = CGRectMake(10, 420, 300, 50)
            self.addIngredientView.cancelButton.frame = CGRectMake(10, 500, 300, 50)
            
            validAmount = true
            validDescription = true
        }
        else {
            addIngredientView.saveButton.enabled = false
            addIngredientView.saveButton.alpha = 0.5
        }
    }
    
    // MARK: Picker View
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return measurementTypesList.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return measurementTypesList[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickerIndex = row
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Helper Functions
    func clickedSaveButton() {
        let newIngredient: Ingredient = Ingredient(amount: 0.0, amountFrac: "", type: self.measurementTypesList[self.pickerIndex], name: self.addIngredientView.descriptionField.text!)
        newIngredient.amount = Float(self.addIngredientView.amountField.text!)!
        self.delegate = sender
        if isEdit == true {
            self.delegate?.sendDataToRecipeManager2(self, ingredient: newIngredient, index: self.index!)
        }
        else {
            self.delegate?.sendDataToRecipeManager2(self, ingredient: newIngredient, index: -1)
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func clickedCancelButton() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func clickedDeleteButton() {
        self.delegate = sender
        self.ingredient?.amount = -1.0
        self.delegate?.sendDataToRecipeManager2(self, ingredient: self.ingredient!, index: self.index!)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func textChangedAmount() {

        let textField = self.addIngredientView.amountField
        validAmount = (textField.text != "")
        if validAmount == true {
            var dotCount = 0
            var badCount = 0
            var goodCount = 0
            for char in textField.text!.characters {
                if char == "." {
                    dotCount += 1
                }
                else if char > "9" || char < "0" {
                    badCount += 1
                }
                else {
                    goodCount += 1
                }
            }
            if dotCount == 1 && goodCount < 2 {
                validAmount = false
            }
            else if dotCount > 1 || badCount > 0 {
                validAmount = false
            }
        }
        if validAmount == true && validDescription == true {
            self.addIngredientView.saveButton.enabled = true
            self.addIngredientView.saveButton.alpha = 1.0
        }
        else {
            self.addIngredientView.saveButton.enabled = false
            self.addIngredientView.saveButton.alpha = 0.5
        }
    }
    
    func textChangedDescription(sender: AnyObject) {
        let textField = self.addIngredientView.descriptionField
        validDescription = (textField.text != "")
        if validAmount == true && validDescription == true {
            self.addIngredientView.saveButton.enabled = true
            self.addIngredientView.saveButton.alpha = 1.0
        }
        else {
            self.addIngredientView.saveButton.enabled = false
            self.addIngredientView.saveButton.alpha = 0.5
        }
    }
}
