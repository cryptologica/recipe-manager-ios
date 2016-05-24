//
//  RecipeManagerViewController.swift
//  final_project
//
//  Created by JT Newsome on 4/27/16.
//  Copyright © 2016 JT Newsome. All rights reserved.
//

import UIKit

protocol HomeScreenDelegate: class {
    
    func sendDataToRecipeListViewController(sender: RecipeManagerViewController, recipe: Recipe, index: Int)
}

protocol AddIngredientDelegate: class {
    
    func sendDataToAddIngredientViewController(sender: RecipeManagerViewController, ingredient: Ingredient?, index: Int, isEdit: Bool)
}

protocol DensityDatabaseDelegate: class {
    
    func sendDataToDensityDatabaseViewController(sender: RecipeManagerViewController, ingredient: Ingredient, index: Int)
}

protocol DirectionsDelegate: class {
    
    func sendDataToDirectionsViewController(sender: RecipeManagerViewController, recipe: Recipe, index: Int)
}

class RecipeManagerViewController: UIViewController, RecipeManagerDelegate, RecipeManagerDelegate2, RecipeManagerDelegate3, RecipeManagerDelegate4, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource  {
    
    weak var delegate: HomeScreenDelegate? = nil
    
    weak var addIngredientDelegate: AddIngredientDelegate?  = nil
    
    weak var densityDatabaseDelegate: DensityDatabaseDelegate? = nil
    
    weak var directionsDelegate: DirectionsDelegate? = nil
    
    var currRecipe: Recipe?
    
    var tableView: UITableView = UITableView()
    
    var recipeIndex: Int?
    
    var isEditMode = false
    
    var validAmount = false
    var validDescription = false
    
    var pickerViewList: [String] = ["1/4", "1/2", "1", "2", "3", "4", "—"]
    
    var measurementTypesList: [String] = ["pound", "ounce", "gallon", "pint", "quart", "cup", "pinch", "count", "tablespoon", "teaspoon", "mililiter", "liter", "gram", "kilogram", "fl. ounce", "jigger"]
    
    private var recipeManagerView: RecipeManagerView! {
        return (view as! RecipeManagerView)
    }
    
    override func loadView() {
        view = RecipeManagerView(frame: CGRectZero)
        
        print("Loaded: RecipeManagerViewController")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let recipeListRect = CGRectMake(0, 190.5, 325, 325)
        tableView.frame = recipeListRect
        tableView.backgroundColor = UIColor.clearColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.recipeManagerView.conversionFactorTextField.delegate = self
        self.recipeManagerView.servingsTextField.delegate = self
        self.recipeManagerView.conversionFactorPicker.delegate = self
        self.recipeManagerView.conversionFactorPicker.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(RecipeManagerViewController.clickedAddButton))
        
        self.recipeManagerView.directionsButton.addTarget(self, action: #selector(RecipeManagerViewController.clickedDirectionsButton), forControlEvents: .TouchUpInside)
        
        self.recipeManagerView.sysOfMeasureControl.addTarget(self, action: #selector(RecipeManagerViewController.measurementSystemBtnClicked), forControlEvents: .ValueChanged)
        
        self.recipeManagerView.editModeLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RecipeManagerViewController.clickedEditButton)))
        
        tableView.showsVerticalScrollIndicator = true
        tableView.scrollEnabled = true
        tableView.separatorStyle = .None
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(IngredientListTableView.self, forCellReuseIdentifier: NSStringFromClass(IngredientListTableView))
        
        view.addSubview(tableView)
    }
    
    // MARK: Receive Data
    // Called when we receive data from RecipeListViewController
    func sendDataToRecipeManager(sender: RecipeListViewController, recipe: Recipe, index: Int) {
        currRecipe = recipe
        self.delegate = sender
        title = currRecipe?.title
        recipeManagerView.conversionFactorTextField.text = String(recipe.conversionFactor)
        recipeManagerView.servingsTextField.text = String(recipe.servings)
        recipeIndex = index
        currRecipe?.ingredients = recipe.ingredients
        recipeManagerView.conversionFactorPicker.selectRow(recipe.pickerIndex, inComponent: 0, animated: false)
        
        if recipe.picture != nil {
            if let image = UIImage(data: recipe.picture!) {
                let width = UIScreen.mainScreen().bounds.size.width
                let height = UIScreen.mainScreen().bounds.size.height - 183.5
                
                let imageView = UIImageView(frame: CGRectMake(0, 183.5, width, height))
                imageView.image = image
                imageView.contentMode = UIViewContentMode.ScaleToFill
                recipeManagerView.addSubview(imageView)
                recipeManagerView.sendSubviewToBack(imageView)
            }
        }
        
        // TOOD: Test this by saving and going back
        if recipe.systemOfMeasurement == "metric" {
            recipeManagerView.sysOfMeasureControl.selectedSegmentIndex = 1
        }
        else if recipe.systemOfMeasurement == "imperial" {
            recipeManagerView.sysOfMeasureControl.selectedSegmentIndex = 0
        }
        
        tableView.reloadData()
        print("Got data from Home Page!")
    }
    
    // Receive from AddIngredientView
    func sendDataToRecipeManager2(sender: AddIngredientViewController, ingredient: Ingredient, index: Int) {
        print("Received data from AddIngredient")
        // Was Add
        if index == -1 {
            self.currRecipe?.ingredients?.append(ingredient)
        }
        // Was Delete
        else if ingredient.amount == -1.0 {
            self.currRecipe?.ingredients?.removeAtIndex(index)
        }
        // Was Edit
        else {
            self.currRecipe?.ingredients![index] = ingredient
        }
        self.tableView.reloadData()
        self.delegate?.sendDataToRecipeListViewController(self, recipe: self.currRecipe!, index: self.recipeIndex!)
    }
    
    func sendDataToRecipeManager3(sender: DensityDatabaseViewController, ingredient: Ingredient, index: Int) {
        print("Received data from DensityDatabase")
        self.currRecipe?.ingredients![index] = ingredient
        self.delegate?.sendDataToRecipeListViewController(self, recipe: self.currRecipe!, index: self.recipeIndex!)
    }
    
    func sendDataToRecipeManager4(sender: DirectionsViewController, recipe: Recipe, index: Int) {
        print("Received data from DirectionsView")
        currRecipe = recipe
        self.delegate?.sendDataToRecipeListViewController(self, recipe: self.currRecipe!, index: self.recipeIndex!)
    }
    
    func findWeightVolumeType(type: String) -> String {
        if type == "cup" {
            return "volume"
        }
        else if type == "tablespoon" {
            return "volume"
        }
        else if type == "teaspoon" {
            return "volume"
        }
        else if type == "pint" {
            return "volume"
        }
        else if type == "quart" {
            return "volume"
        }
        else if type == "ounce" {
            return "volume"
        }
        else if type == "mililiter" {
            return "volume"
        }
        else if type == "liter" {
            return "volume"
        }
        else if type == "pound" {
            return "weight"
        }
        else if type == "kilogram" {
            return "weight"
        }
        else if type == "gram" {
            return "weight"
        }
        else if type == "gallon" {
            return "volume"
        }
        else if type == "pinch" {
            return "volume"
        }
        else if type == "fl. ounce" {
            return "volume"
        }
        else if type == "jigger" {
            return "volume"
        }
        else if type == "count" {
            return "count"
        }
        return "neutral"
    }
    

    // MARK: Add Recipe Button
    func clickedAddButton() {
        let nextVC = AddIngredientViewController(nibName: "AddIngredientViewController", bundle: nil)
        self.addIngredientDelegate = nextVC
        self.addIngredientDelegate?.sendDataToAddIngredientViewController(self, ingredient: nil, index: (self.currRecipe?.ingredients?.count)!, isEdit: false)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func clickedEditButton() {
        if isEditMode == false {
            self.recipeManagerView.editModeLabel.text = "Done"
            self.recipeManagerView.editModeLabel.textColor = UIColor.redColor()
            isEditMode = true
            print("Edit-Mode = ON")
        }
        else {
            self.recipeManagerView.editModeLabel.text = "Edit"
            self.recipeManagerView.editModeLabel.textColor = UIColor.blackColor()
            isEditMode = false
            print("Edit-Mode = OFF")
        }
    }
    
    // MARK: Table: Game List
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(IngredientListTableView), forIndexPath: indexPath) as! IngredientListTableView
        
        cell.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.9, alpha: 0.8)
        
        cell.selectionStyle = .None
        
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        let ingredient = currRecipe?.ingredients![indexPath.section]
        cell.ingredient = ingredient
        cell.amountLabel.text = (ingredient?.amountFrac)!
        cell.typeLabel.text = " \((ingredient?.type)!)\(shouldBePlural((ingredient?.amount)!, type: (ingredient?.type)!)) "
        cell.titleLabel.text = (ingredient?.name)!
        
        return cell
    }
    
    // Do When Selects a Row
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("Clicked: \(indexPath.section)")
        if isEditMode == true {
            let nextVC = AddIngredientViewController(nibName: "AddIngredientViewController", bundle: nil)
            self.addIngredientDelegate = nextVC
            self.addIngredientDelegate?.sendDataToAddIngredientViewController(self, ingredient: self.currRecipe?.ingredients![indexPath.section], index: indexPath.section, isEdit: true)
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        else {
            let nextVC = DensityDatabaseViewController(nibName: "DensityDatabaseViewController", bundle: nil)
            self.densityDatabaseDelegate = nextVC
            self.densityDatabaseDelegate!.sendDataToDensityDatabaseViewController(self, ingredient: (self.currRecipe?.ingredients![indexPath.section])!, index: indexPath.section)
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    // Num Rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Num Sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (currRecipe?.ingredients?.count)!
    }
    
    // Row Height
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    // Set the spacing between sections
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    // Make the background color show through
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clearColor()
        return headerView
    }
    
    
    // MARK: TextField
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        // Was entered text a valid float?
        if let value = Float(textField.text!) {
            
            // Conversion Factor was Edited
            if textField.tag == 1 {
                let newConversionFactor: Float = (textField.text! as NSString).floatValue
                self.currRecipe?.pickerIndex = findPickerIndex(newConversionFactor)
                self.recipeManagerView.conversionFactorPicker.selectRow((self.currRecipe?.pickerIndex)!, inComponent: 0, animated: true)
                self.recipeManagerView.conversionFactorTextField.text = newConversionFactor.description
                let newServings: Float = newConversionFactor * (currRecipe?.originalServings)!
                self.recipeManagerView.servingsTextField.text = newServings.description
                self.currRecipe?.servings = newServings
                self.currRecipe?.conversionFactor = newConversionFactor
            }
            // Servings was Edited
            else if textField.tag == 2 {
                let newServings: Float = (textField.text! as NSString).floatValue
                textField.text = newServings.description
                currRecipe?.servings = newServings
                currRecipe?.originalServings = newServings / (self.currRecipe?.conversionFactor)!
            }
            
            // Save edits
            self.delegate?.sendDataToRecipeListViewController(self, recipe: self.currRecipe!, index: self.recipeIndex!)
            
            print("Ended Editing: \(value)")
        }
        else {
            displayConfirmDialog("Error", message: "You must input a valid number. Please try again!")
            
            // Bad value: reset fields to previous value
            // Conversion Factor
            if textField.tag == 1 {
                self.recipeManagerView.conversionFactorTextField.text = currRecipe?.conversionFactor.description
            }
            // Servings
            else if textField.tag == 2 {
                self.recipeManagerView.servingsTextField.text = currRecipe?.servings.description
            }
            
            print("Ended Editing: Invalid Value")
        }
    }
    
    // MARK: Segmented Control (Imperial/Metric)
    func measurementSystemBtnClicked() {
        // TODO: Convert all ingredients to selected measurement system
        let active = self.recipeManagerView.sysOfMeasureControl.selectedSegmentIndex
        // Imperial
        if active == 0 {
            print("Selected: Imperial")
            for (index, ingredient) in (currRecipe?.ingredients?.enumerate())! {
                let type: String = ingredient.type!
                let sys: String = getMeasurementForType(type)
                if sys == "metric" {
                    if type == "mililiter" {
                        currRecipe?.ingredients![index].amount = (ingredient.amount) * 0.004227
                        currRecipe?.ingredients![index].type = "cup"
                    }
                    else if type == "liter" {
                        currRecipe?.ingredients![index].amount = (ingredient.amount) * 0.2642
                        currRecipe?.ingredients![index].type = "gallon"
                    }
                    else if type == "kilogram" {
                        currRecipe?.ingredients![index].amount = (ingredient.amount) * 2.205
                        currRecipe?.ingredients![index].type = "pound"
                    }
                    else if type == "gram" {
                        currRecipe?.ingredients![index].amount = (ingredient.amount) * 0.03527
                        currRecipe?.ingredients![index].type = "ounce"
                    }
                    currRecipe?.ingredients![index].amount = round(ingredient.amount * 100) / 100
                    updateAmountMeasurement(index)
                }
            }
            self.tableView.reloadData()
            self.delegate?.sendDataToRecipeListViewController(self, recipe: currRecipe!, index: recipeIndex!)
        }
        // Metric
        else if active == 1 {
            print("Selected: Metric")
            for (index, ingredient) in (currRecipe?.ingredients?.enumerate())! {
                let type: String = ingredient.type!
                let sys: String = getMeasurementForType(type)
                if sys == "imperial" {
                    if type == "cup" {
                        currRecipe?.ingredients![index].amount = ingredient.amount * 236.6
                        currRecipe?.ingredients![index].type = "mililiter"
                    }
                    else if type == "tablespoon" {
                        currRecipe?.ingredients![index].amount = ingredient.amount * 14.79
                        currRecipe?.ingredients![index].type = "mililiter"
                    }
                    else if type == "teaspoon" {
                        currRecipe?.ingredients![index].amount = ingredient.amount * 4.929
                        currRecipe?.ingredients![index].type = "mililiter"
                    }
                    else if type == "pint" {
                        currRecipe?.ingredients![index].amount = ingredient.amount * 473.2
                        currRecipe?.ingredients![index].type = "mililiter"
                    }
                    else if type == "quart" {
                        currRecipe?.ingredients![index].amount = ingredient.amount * 946.4
                        currRecipe?.ingredients![index].type = "mililiter"
                    }
                    else if type == "ounce" {
                        currRecipe?.ingredients![index].amount = ingredient.amount * 28.35
                        currRecipe?.ingredients![index].type = "gram"
                    }
                    else if type == "pound" {
                        currRecipe?.ingredients![index].amount = ingredient.amount * 453.6
                        currRecipe?.ingredients![index].type = "gram"
                    }
                    else if type == "gallon" {
                        currRecipe?.ingredients![index].amount = ingredient.amount * 3785.0
                        currRecipe?.ingredients![index].type = "mililiter"
                    }
                    else if type == "fl. ounce" {
                        currRecipe?.ingredients![index].amount = ingredient.amount * 29.57
                        currRecipe?.ingredients![index].type = "mililiter"
                    }
                    else if type == "jigger" {
                        currRecipe?.ingredients![index].amount = ingredient.amount * 44.36
                        currRecipe?.ingredients![index].type = "mililiter"
                    }
                    currRecipe?.ingredients![index].amount = round(ingredient.amount * 100) / 100
                    updateAmountMeasurement(index)
                }
            }
            self.tableView.reloadData()
            self.delegate?.sendDataToRecipeListViewController(self, recipe: currRecipe!, index: recipeIndex!)
        }
    }
    
    // MARK: Picker View
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // Conversion Factor Picker
        if pickerView.tag == 3 {
            return pickerViewList.count
        }
        
        print("ERROR: pickerView(numOfRowsInComponent)")
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        // Conversion Factor Picker
        if pickerView.tag == 3 {
            return pickerViewList[row]
        }
        
        print("ERROR: pickerView(titleForRow)")
        return "UNKNOWN"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // Conversion Factor Picker
        if pickerView.tag == 3 {
            if pickerViewList[row] != "—" {
                let newConversionFactor: Float = fracToDecimal(pickerViewList[row])
                self.updateIngredients(newConversionFactor)
                self.tableView.reloadData()
                recipeManagerView.conversionFactorTextField.text = newConversionFactor.description
                let newServings: Float = newConversionFactor * (currRecipe?.originalServings)!
                self.recipeManagerView.servingsTextField.text = newServings.description
                self.currRecipe?.servings = newServings
                self.currRecipe?.conversionFactor = newConversionFactor
            }
            
            self.currRecipe?.pickerIndex = row
            self.delegate?.sendDataToRecipeListViewController(self, recipe: self.currRecipe!, index: self.recipeIndex!)
        }
    }
    
    // MARK: Touches Began
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.recipeManagerView.conversionFactorTextField.resignFirstResponder()
        self.recipeManagerView.servingsTextField.resignFirstResponder()
    }
    
    
    // MARK: Dialog Handlers
    // Display a prompt with the given title and message
    func displayConfirmDialog(title: String, message: String) {
        dispatch_async(dispatch_get_main_queue(), {
            let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                self.recipeManagerView.conversionFactorTextField.text = "1.0"
            }))
            let subview = refreshAlert.view.subviews.first! as UIView
            let alertContentView = subview.subviews.first! as UIView
            alertContentView.backgroundColor = UIColor.whiteColor()
            alertContentView.tintColor = UIColor.darkGrayColor()
            self.presentViewController(refreshAlert, animated: true, completion: nil)
        })
    }
    
    // MARK: Helper Functions
    func findPickerIndex(num: Float) -> Int {
        
        if num < 0.25 || num > 4.0 {
            return 7
        }
        
        var returnVal = -1
        for (index, pickerVal) in pickerViewList.enumerate() {
            if num == fracToDecimal(pickerVal) {
                returnVal = index
                break
            }
        }
        
        if returnVal == -1 {
            return pickerViewList.count
        }
        
        return returnVal
    }
    
    func shouldBePlural(amount: Float, type: String) -> String {
        if amount > 1 {
            if type == "pinch" {
                return "es"
            }
            else {
                return "s"
            }
        }
        else {
            return ""
        }
    }
    
    func fracToDecimal(fraction: String) -> Float {
        let split = fraction.componentsSeparatedByString("/")
        if split.count == 2 {
            return (split[0] as NSString).floatValue / (split[1] as NSString).floatValue
        }
        else {
            return (split[0] as NSString).floatValue
        }
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
    
    func findMeasurementIndex(type: String) -> Int {
        for (index, listVal) in measurementTypesList.enumerate() {
            if type == listVal {
                return index
            }
        }
        
        print("Error: findMeasurementIndex()")
        return measurementTypesList.count
    }
    
    func updateIngredients(newConversionFactor: Float) {
        let origConversionFactor = (self.currRecipe?.servings)! / (self.currRecipe?.originalServings)!
        for (index, ingredient) in (self.currRecipe?.ingredients!.enumerate())! {
            let origAmt = ingredient.amount / origConversionFactor
            let newAmt = origAmt * newConversionFactor
            self.currRecipe?.ingredients![index].amount = newAmt
            
            // Update measurement if amount is now too small/large
            updateAmountMeasurement(index)
        }
    }
    
    // Called when you multiply or divide ingredient amounts to make
    // sure that amounts are displayed in a appropriate measurement type.
    func updateAmountMeasurement(ingredientListIndex: Int) {
        let isMetric = self.recipeManagerView.isMetric
        let ingredient = self.currRecipe?.ingredients![ingredientListIndex]
        var newAmt: Float = (ingredient?.amount)!
        var newType: String = (ingredient?.type)!
        
        var count = 0
        var shouldExit = false
        var min: Float
        var max: Float
        while shouldExit == false {
            count += 1
            if count > 1000 {
                shouldExit = true
                print("WARNING: Infinite Loop - newAmt = \(newAmt), newType = \(newType)")
            }
            else if newType == "cup" {
                max = 4.0    // 4 Cups  = 1 Quart
                min = 0.125  // 1/8 Cup = 2 Tablespoon
                if newAmt >= max {
                    newAmt = newAmt / 4
                    newType = "quart"
                    continue
                }
                else if newAmt < min {
                    newAmt = (newAmt * 2) / 0.125
                    newType = "tablespoon"
                    continue
                }
                else {
                    let split = (ingredient?.decimalToFrac(newAmt))!.componentsSeparatedByString("/")
                    let isInt: Bool = (floorf(newAmt) == newAmt)
                    if split.count < 2  && isInt == false {
                        print("splt < 2 : count = \(split.count) for \(newAmt)")
                        newAmt = (newAmt * 2) / 0.125
                        newType = "tablespoon"
                    }
                    shouldExit = true
                }
            }
            else if newType == "tablespoon" {
                max = 4.0    // 4 Tablespoons = 1/4 Cup
                min = 1.0    // 1 Tablespoon  = 3 teaspoons
                if newAmt >= max {
                    newAmt = (newAmt / 4) * 0.25
                    newType = "cup"
                    continue
                }
                else if newAmt < min {
                    newAmt = newAmt * 3
                    newType = "teaspoon"
                    continue
                }
                else {
                    shouldExit = true
                }
            }
            else if newType == "teaspoon" {
                max = 3.0      // 3 teaspoons  = 1 Tablespoon
                min = 0.125    // 1/8 teaspoon = 1 Pinch
                if newAmt >= max {
                    newAmt = newAmt / 3
                    newType = "tablespoon"
                    continue
                }
                else if newAmt < min {
                    newAmt = (newAmt * 1) / 0.125
                    newType = "pinch"
                    continue
                }
                else {
                    shouldExit = true
                }
            }
            else if newType == "pint" {
                max = 2.0      // 2 Pints = 1 Quart
                min = 1.0      // 1 Pint  = 2 Cups
                if newAmt >= max {
                    newAmt = newAmt / 2
                    newType = "quart"
                    continue
                }
                else if newAmt < min {
                    newAmt = newAmt * 2
                    newType = "cup"
                    continue
                }
                else {
                    shouldExit = true
                }
            }
            else if newType == "quart" {
                max = 4.0    // 4 Quarts = 1 Gallon
                min = 1.0    // 1 Quart  = 2 Pints
                if newAmt >= max {
                    newAmt = newAmt / 4
                    newType = "gallon"
                    continue
                }
                else if newAmt < min {
                    newAmt = newAmt * 2
                    newType = "pint"
                    continue
                }
                else {
                    shouldExit = true
                }
            }
            else if newType == "ounce" {
                max = 16.0    // 16 Ounces = 1 Pound
                if newAmt >= max {
                    newAmt = newAmt / 16
                    newType = "pound"
                    continue
                }
                else {
                    shouldExit = true
                }
            }
            else if newType == "mililiter" {
                max = 1000.0    // 1000 mL = 1 Liter
                if newAmt >= max {
                    newAmt = newAmt / 1000
                    newType = "liter"
                    continue
                }
                else {
                    shouldExit = true
                }
            }
            else if newType == "liter" {
                min = 1.0    // 1 Liter  = 1000 mL
                if newAmt < min {
                    newAmt = newAmt * 1000
                    newType = "mililiter"
                    continue
                }
                else {
                    shouldExit = true
                }
            }
            else if newType == "pound" {
                min = 1.0    // 1 Pound  = 16 Ounces
                if newAmt < min {
                    newAmt = newAmt * 16
                    newType = "ounce"
                    continue
                }
                else {
                    shouldExit = true
                }
            }
            else if newType == "kilogram" {
                min = 1.0    // 1 Kilogram  = 1000 Grams
                if newAmt < min {
                    newAmt = newAmt * 1000
                    newType = "gram"
                    continue
                }
                else {
                    shouldExit = true
                }
            }
            else if newType == "gram" {
                max = 1000.0    // 1000 Grams = 1 Kilogram
                if newAmt >= max {
                    newAmt = newAmt / 1000
                    newType = "kilogram"
                    continue
                }
                else {
                    shouldExit = true
                }
            }
            else if newType == "gallon" {
                min = 1.0    // 1 Gallon  = 4 Quarts
                if newAmt < min {
                    newAmt = newAmt * 4
                    newType = "quart"
                    continue
                }
                else {
                    shouldExit = true
                }
            }
            else if newType == "pinch" {
                if isMetric {
                    max = 4   // 4 Pinches = 2.464 mL
                    if newAmt >= max {
                        newAmt = (newAmt / 4) * 2.464
                        newType = "mililiter"
                        continue
                    }
                    else {
                        shouldExit = true
                    }
                }
                else {
                    max = 4   // 4 Pinches = 0.5 Teaspoons
                    if newAmt >= max {
                        newAmt = (newAmt / 4) * 0.5
                        newType = "teaspoon"
                        continue
                    }
                    else {
                        shouldExit = true
                    }
                }
            }
            else if newType == "fl. ounce" {
                if isMetric {
                    max = 33.81   // 33.81 fluid ounces = 1 Liter
                    if newAmt >= max {
                        newAmt = newAmt / 33.81
                        newType = "liter"
                        continue
                    }
                    else {
                        shouldExit = true
                    }
                }
                else {
                    max = 64.0   // 64 fluid ounce  = 1 Gallon
                    min = 8.0    // 8 fluid ounces  = 1 Cup
                    if newAmt >= max {
                        newAmt = newAmt / 64
                        newType = "gallon"
                        continue
                    }
                    else if newAmt < min {
                        newAmt = (newAmt * 1) / 8
                        newType = "cup"
                        continue
                    }
                    else {
                        shouldExit = true
                    }
                }
            }
            else if newType == "jigger" {
                max = 4.0   // 4 Jiggers = 6 Fluid Ounces
                if newAmt >= max {
                    newAmt = (newAmt / 4) * 6
                    newType = "fl. ounce"
                    continue
                }
                else {
                    shouldExit = true
                }
            }
            else if newType == "count" {
                shouldExit = true
            }
            else {
                shouldExit = true
            }
        }
        
        self.currRecipe?.ingredients![ingredientListIndex].amount = newAmt
        self.currRecipe?.ingredients![ingredientListIndex].type = newType
    }
    
    func getMeasurementForType(type: String) -> String {
        if type == "cup" {
            return "imperial"
        }
        else if type == "tablespoon" {
            return "imperial"
        }
        else if type == "teaspoon" {
            return "imperial"
        }
        else if type == "pint" {
            return "imperial"
        }
        else if type == "quart" {
            return "imperial"
        }
        else if type == "ounce" {
            return "imperial"
        }
        else if type == "mililiter" {
            return "metric"
        }
        else if type == "liter" {
            return "metric"
        }
        else if type == "pound" {
            return "imperial"
        }
        else if type == "kilogram" {
            return "metric"
        }
        else if type == "gram" {
            return "metric"
        }
        else if type == "gallon" {
            return "imperial"
        }
        else if type == "pinch" {
            return "neutral"
        }
        else if type == "fl. ounce" {
            return "imperial"
        }
        else if type == "jigger" {
            return "imperial"
        }
        else if type == "count" {
            return "neutral"
        }
        return "neutral"
    }
    
    func clickedDirectionsButton() {
        let VC = DirectionsViewController(nibName: "DirectionsViewController", bundle: nil)
        self.directionsDelegate = VC
        directionsDelegate?.sendDataToDirectionsViewController(self, recipe: currRecipe!, index: recipeIndex!)
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
