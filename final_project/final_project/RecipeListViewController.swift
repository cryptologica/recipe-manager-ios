//
//  RecipeListViewController.swift
//  final_project
//
//  Created by JT Newsome on 4/23/16.
//  Copyright © 2016 JT Newsome. All rights reserved.
//

import UIKit

protocol RecipeManagerDelegate: class {
    
    func sendDataToRecipeManager(sender: RecipeListViewController, recipe: Recipe, index: Int)
}

class RecipeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, HomeScreenDelegate {

    weak var delegate: RecipeManagerDelegate? = nil
    
    var tableData: [Recipe] = []
    var filteredTableData = [Recipe]()
    var tableView: UITableView = UITableView()
    var resultSearchController = UISearchController(searchResultsController: nil)
    
    var header: HeaderView?
    
    let cellSpacingHeight: CGFloat = 7
    var isEditMode = false
    
    private var recipeListView: RecipeListView! {
        return (view as! RecipeListView)
    }
    
    override func loadView() {
        view = RecipeListView(frame: CGRectZero)
        
        header = HeaderView(frame: CGRectMake(0, 518, 320, 50))
        view.addSubview(header!)
        
        print("Loaded: RecipeListViewController")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        
        let imageView = UIImageView(frame: CGRectMake(0, 0, width, height))
        imageView.image = UIImage(named: "home_bg.png")!
        imageView.autoresizingMask = [UIViewAutoresizing.FlexibleBottomMargin, UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleRightMargin, UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleTopMargin, UIViewAutoresizing.FlexibleWidth]
        imageView.contentMode = UIViewContentMode.ScaleToFill
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
        
        let recipeListRect = CGRectMake(0, 64, UIScreen.mainScreen().bounds.width, 454)
        tableView.frame = recipeListRect
        tableView.backgroundColor = UIColor.clearColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Recipes"
        
        // Add Recipe Btn (NavBar)
        let btnColor = UIColor.blackColor()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(RecipeListViewController.clickedAddButton))
        navigationItem.rightBarButtonItem?.tintColor = btnColor
        
        // Edit Recipe Btn (NavBar)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: #selector(RecipeListViewController.clickedEditButton))
        navigationItem.leftBarButtonItem?.tintColor = btnColor
        
        header?.addLabel?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RecipeListViewController.clickedAddButton)))
        header?.imageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RecipeListViewController.clickedAddButton)))
        
        resultSearchController.searchBar.sizeToFit()
        resultSearchController.searchResultsUpdater = self
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.searchBar.barTintColor = UIColor(hue: 0, saturation: 0, brightness: 0.8, alpha: 0.1)
        resultSearchController.searchBar.tintColor = UIColor.orangeColor()
        resultSearchController.searchBar.showsCancelButton = false
        tableView.tableHeaderView = resultSearchController.searchBar
        tableView.addSubview(resultSearchController.searchBar)

        tableView.showsVerticalScrollIndicator = true
        tableView.scrollEnabled = true
        tableView.bounces = true
        tableView.separatorStyle = .None
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(RecipeTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(RecipeTableViewCell))
        
        view.addSubview(tableView)
        
        loadData()
    }
    
    // MARK: Save/Load
    func saveData() {
        let data = NSKeyedArchiver.archivedDataWithRootObject(tableData)
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let filename = paths[0].stringByAppendingString("recipes.txt")
        data.writeToFile(filename, atomically: true)
    }
    
    func loadData() {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let filename = paths[0].stringByAppendingString("recipes.txt")
        if let data = NSKeyedUnarchiver.unarchiveObjectWithFile(filename) as? [Recipe] {
            tableData = data
        }
    }
    
    func clearData() {
        tableData = []
        saveData()
    }
    
    // Mark: Receive Data
    // Called when we receive data from RecipeManager
    func sendDataToRecipeListViewController(sender: RecipeManagerViewController, recipe: Recipe, index: Int) {
        tableData[index] = recipe
        saveData()
        print("Data Received from RecipeManager!")
    }
    
    // MARK: Table: Recipe List
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(RecipeTableViewCell), forIndexPath: indexPath) as! RecipeTableViewCell
        
        cell.backgroundColor = UIColor(hue: 0, saturation: 0.2, brightness: 0.9, alpha: 0.7)
        
        cell.selectionStyle = .None
        cell.accessoryType = .DisclosureIndicator
        
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        if (self.resultSearchController.active) {
            cell.recipe = filteredTableData[indexPath.section]
            cell.titleLabel.text = filteredTableData[indexPath.section].title
            return cell
        }
        else {
            cell.recipe = tableData[indexPath.section]
            cell.titleLabel.text = tableData[indexPath.section].title
            return cell
        }
    }
    
    // Do When Selects a Row
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("Clicked: \(tableData[indexPath.section].title)")
        
        // EDIT RECIPE
        if isEditMode == true {
            displayEditRecipeModal(indexPath.section)
        }
        // OPEN RECIPE
        else {
            let nextVC = RecipeManagerViewController(nibName: "RecipeManagerViewController", bundle: nil)
            self.delegate = nextVC
            self.delegate?.sendDataToRecipeManager(self, recipe: tableData[indexPath.section], index: indexPath.section)
            self.navigationController?.pushViewController(nextVC, animated: false)
        }
    }
    
    // Num Rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Num Sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if (self.resultSearchController.active) {
            return self.filteredTableData.count
        }
        else {
            return self.tableData.count
        }
    }
    
    // Row Height
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    // Set the spacing between sections
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    // Make the background color show through
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clearColor()
        return headerView
    }
    
    // MARK: Search Bar
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let tableBounds = self.tableView.bounds
        let searchBarFrame = self.resultSearchController.searchBar.frame
        
        self.resultSearchController.searchBar.frame = CGRectMake(tableBounds.origin.x, tableBounds.origin.y, searchBarFrame.size.width, searchBarFrame.size.height)
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filteredTableData.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF.title CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (tableData as NSArray).filteredArrayUsingPredicate(searchPredicate)
        filteredTableData = array as! [Recipe]
        
        // Don't count empty search as a constraint (which would always return nothing)
        if searchController.searchBar.text == "" {
            filteredTableData = tableData
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: Import Recipe
    func importRecipeData(recipeIndex: Int) {
        let currRecipe: Recipe = self.tableData[recipeIndex]
        let importCode: Int = currRecipe.importCode

        // Get HTML from this URL
        let url = NSURL(string: "http://allrecipes.com/recipe/\(importCode)/")!
        var stringData: NSString? = try? NSString(contentsOfURL: url, encoding: NSMacOSRomanStringEncoding)
        if stringData != nil {
            let originalStringData = stringData
            
            // Get SERVINGS from HTML
            let servingsStartRange: NSRange = stringData!.rangeOfString("name=\"servings\"")
            if servingsStartRange.location != NSNotFound {
                stringData = stringData!.substringFromIndex(servingsStartRange.location + servingsStartRange.length)
                let dataOriginalStartRange: NSRange = stringData!.rangeOfString("data-original=\"")
                if dataOriginalStartRange.location != NSNotFound {
                    stringData = stringData!.substringFromIndex(dataOriginalStartRange.location + dataOriginalStartRange.length)
                    let servingsEndRange: NSRange = stringData!.rangeOfString("\"")
                    if servingsStartRange.location != NSNotFound {
                        stringData = stringData!.substringToIndex(servingsEndRange.location)
                        tableData[recipeIndex].servings = Float(stringData! as String)!
                        tableData[recipeIndex].originalServings = tableData[recipeIndex].servings
                        stringData = originalStringData
                        print(tableData[recipeIndex].servings)
                    }
                }
            }
            
            // Get each DIRECTION from HTML
            var keepGoing = true
            while keepGoing {
                let directionStartRange: NSRange = stringData!.rangeOfString("<span class=\"recipe-directions__list--item\">")
                if directionStartRange.location != NSNotFound {
                    stringData = stringData!.substringFromIndex(directionStartRange.location + directionStartRange.length)
                    let directionEndRange: NSRange = stringData!.rangeOfString("</span>")
                    if directionEndRange.location != NSNotFound {
                        tableData[recipeIndex].directions!.append(String(stringData!.substringToIndex(directionEndRange.location)))
                        stringData = stringData!.substringFromIndex(directionEndRange.location + directionEndRange.length)
                    }
                    else {
                        keepGoing = false
                    }
                }
                else{
                    keepGoing = false
                }
            }
            
            // Get each INGREDIENT from HTML
            stringData = originalStringData
            keepGoing = true
            while keepGoing {
                let ingredientStartRange: NSRange = stringData!.rangeOfString("itemprop=\"ingredients\">")
                if ingredientStartRange.location != NSNotFound {
                    stringData = stringData!.substringFromIndex(ingredientStartRange.location + ingredientStartRange.length)
                    let ingredientEndRange: NSRange = stringData!.rangeOfString("</span>")
                    if ingredientEndRange.location != NSNotFound {
                        let ingredient: String = String(stringData!.substringToIndex(ingredientEndRange.location))
                        tableData[recipeIndex].ingredients!.append(processIngredient(ingredient))
                    }
                    else {
                        keepGoing = false
                    }
                }
                else {
                    keepGoing = false
                }
            }
            
            // Get image
            stringData = originalStringData
            let imageStartRange: NSRange = stringData!.rangeOfString("<img class=\"rec-photo\" src=\"")
            if imageStartRange.location != NSNotFound {
                stringData = stringData!.substringFromIndex(imageStartRange.location + imageStartRange.length)
                let imageEndRange: NSRange = stringData!.rangeOfString("\"")
                if imageEndRange.location != NSNotFound {
                    let imageUrlString: String? = String(stringData!.substringToIndex(imageEndRange.location))
                    let imageURL: NSURL? = NSURL(string: imageUrlString!)
                    if imageURL != nil {
                        let imageData: NSData? = NSData(contentsOfURL: imageURL!)
                        if imageData != nil {
                            tableData[recipeIndex].picture = imageData
                        }
                    }
                }
            }
          
            saveData()
            // End Processing
        }
        else {
            displayConfirmDialog("Error", message: "Was unable to import data for this recipe.")
        }
    }
    
    func processIngredient(ingredient: String) -> Ingredient {
        let components = ingredient.componentsSeparatedByString(" ")
        var fraction = components[0].componentsSeparatedByString("/")
        var amount: Float
        var measurementIndex: Int
        if fraction.count == 2 {
            amount = (fraction[0] as NSString).floatValue / (fraction[1] as NSString).floatValue
            measurementIndex = 1
        }
        else {
            amount = (fraction[0] as NSString).floatValue
            if amount == 0 {
                measurementIndex = 0
            }
            else {
                measurementIndex = 1
                
                fraction = components[1].componentsSeparatedByString("/")
                if fraction.count == 2 {
                    amount += (fraction[0] as NSString).floatValue / (fraction[1] as NSString).floatValue
                    measurementIndex = 2
                }
                else {
                    let maybeNumber = (fraction[0] as NSString).floatValue
                    if maybeNumber > 0.0 {
                        amount += maybeNumber
                        measurementIndex = 2
                    }
                    else {
                        measurementIndex = 1
                    }
                }
            }
        }
        let type = findMeasurementType(components[measurementIndex])
        var name = ""
        if type == "fl. ounce" {
            measurementIndex += 1
        }
        // Non-specific measurement type
        if type == "count" {
            for (index, str) in components.enumerate() {
                if index >= measurementIndex {
                    name += " \(str)"
                }
            }
        }
        // Was a valid measurement type
        else {
            
            for (index, str) in components.enumerate() {
                if index > measurementIndex {
                    name += " \(str)"
                }
            }
        }
        name = name.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        // TOOD:  Remove print line
        print("\(ingredient) => \(amount) \(type) \(name)")
        return Ingredient(amount: amount, amountFrac: decimalToFrac(amount), type: type, name: name)
    }
    
    func findMeasurementType(type: String) -> String {
        let t = (type.lowercaseString).stringByReplacingOccurrencesOfString(".", withString: "")
        let measurementType: String
        if t == "cup" || t == "cups" || t == "c" {
            measurementType = "cup"
        }
        else if t == "tablespoon" || t == "tablespoons" || t == "tbsp" || t == "tbl" || t == "tb" || t == "t" {
            measurementType = "tablespoon"
        }
        else if t == "teaspoon" || t == "teaspoons" || t == "tsp" || t == "t" {
            measurementType = "teaspoon"
        }
        else if t == "pint" || t == "pt" {
            measurementType = "pint"
        }
        else if t == "quart" || t == "qt" {
            measurementType = "quart"
        }
        else if t == "ounce" || t == "ounces" || t == "oz" {
            measurementType = "ounce"
        }
        else if t == "mililiter" || t == "mililiters" || t == "ml" {
            measurementType = "mililiter"
        }
        else if t == "liter" || t == "l" {
            measurementType = "liter"
        }
        else if t == "pound" || t == "pounds" || t == "lb" || t == "lbs" {
            measurementType = "pound"
        }
        else if t == "kilogram" || t == "kilograms" || t == "kg" || t == "kgs" {
            measurementType = "kilogram"
        }
        else if t == "gram" || t == "grams" || t == "g" {
            measurementType = "gram"
        }
        else if t == "gallon" || t == "gallons" {
            measurementType = "gallon"
        }
        else if t == "quart" || t == "quarts" {
            measurementType = "quart"
        }
        // TODO: salt "and" pepper, to taste?
        else if t == "pinch" || t == "dash" {
            measurementType = "pinch"
        }
        else if t == "fluid" || t == "fl" {
            measurementType = "fl. ounce"
        }
        else if t == "jigger" {
            measurementType = "jigger"
        }
        else {
            measurementType = "count"
        }
        return measurementType
    }
    
    // MARK: Add Recipe
    func clickedAddButton() {
        print("Clicked Add Button!")
        
        var recipeNameField: UITextField!
        var importCodeField: UITextField!
        
        // Make a Create Recipe Alert Modal
        let refreshAlert = UIAlertController(title: "NEW RECIPE", message: "Enter a title and a recipe ID (optional) if you wish to import recipe ingredients and directions from AllRecipes.com.", preferredStyle: UIAlertControllerStyle.Alert)
        
        // Title Input
        refreshAlert.addTextFieldWithConfigurationHandler({ (textField: UITextField!) in
            textField.addTarget(self, action: #selector(RecipeListViewController.textChangedCreateRecipe(_:)), forControlEvents: .EditingChanged)
            recipeNameField = textField
            recipeNameField.placeholder = "Title"
        })
        
        // Import Input
        refreshAlert.addTextFieldWithConfigurationHandler({ (textField: UITextField!) in
            importCodeField = textField
            importCodeField.placeholder = "allrecipes.com/recipe/{ID HERE}/..."
            
            // TODO: Uncheck 'Connect Hardware Keyboard' on iPhone Simulator (README)
            importCodeField.keyboardType = .NumberPad
        })
        
        // Create Button
        refreshAlert.addAction(UIAlertAction(title: "Create", style: .Default, handler: { (action: UIAlertAction!) in
            let importCode = importCodeField.text!
            let newRecipe: Recipe
            if importCode == "" {
                newRecipe = Recipe(title: recipeNameField.text!, importCode: -1)
                self.tableData.insert(newRecipe, atIndex: 0)
            }
            else {
                newRecipe = Recipe(title: recipeNameField.text!, importCode: Int(importCodeField.text!)!)
                self.tableData.insert(newRecipe, atIndex: 0)
                self.importRecipeData(0)
            }
            
            self.tableView.reloadData()
            self.saveData()
            print("Add Recipe: Successful")
        }))
        
        // Cancel Button
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            print("Add Recipe: Cancelled")
        }))
        
        // Dispatch Alert
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(refreshAlert, animated: true, completion: {
                (refreshAlert.actions[0]).enabled = false
                print("Add Recipe Alert Loaded!")
            })
        })
    }
    
    // MARK: Edit Recipe
    func clickedEditButton() {
        if isEditMode == false {
            navigationItem.leftBarButtonItem?.title = "Done"
            navigationItem.leftBarButtonItem?.tintColor = UIColor.redColor()
            isEditMode = true
            print("Edit-Mode = ON")
        }
        else {
            navigationItem.leftBarButtonItem?.title = "Edit"
            navigationItem.leftBarButtonItem?.tintColor = UIColor.blackColor()
            isEditMode = false
            print("Edit-Mode = OFF")
        }
    }
    
    func displayEditRecipeModal(recipeIndex: Int) {
        var recipeNameField: UITextField!
        
        let currTitle: String = tableData[recipeIndex].title!
        
        // Make a Create Recipe Alert Modal
        let refreshAlert = UIAlertController(title: "EDIT RECIPE", message: "Tap 'Save' to store your changes or tap 'Delete' to completely remove this recipe.", preferredStyle: UIAlertControllerStyle.Alert)
        
        // Title Input
        refreshAlert.addTextFieldWithConfigurationHandler({ (textField: UITextField!) in
            textField.addTarget(self, action: #selector(RecipeListViewController.textChangedEditRecipe(_:)), forControlEvents: .EditingChanged)
            recipeNameField = textField
            recipeNameField.placeholder = "Title"
            recipeNameField.text = currTitle
        })
        
        // Save Button
        refreshAlert.addAction(UIAlertAction(title: "Save", style: .Default, handler: { (action: UIAlertAction!) in
            self.tableData[recipeIndex].title = recipeNameField.text!
            self.tableView.reloadData()
            self.saveData()
            print("Recipe Saved!")
        }))
        
        // Delete Button
        refreshAlert.addAction(UIAlertAction(title: "Delete", style: .Destructive, handler: { (action: UIAlertAction!) in
            self.tableData.removeAtIndex(recipeIndex)
            self.tableView.reloadData()
            self.saveData()
            print("Recipe Deleted")
        }))
        
        // Cancel Button
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
            print("Edit Recipe: Cancelled")
        }))
        
        // Dispatch Alert
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(refreshAlert, animated: true, completion: {
                print("Add Recipe Alert Loaded!")
            })
        })
    }
    
    func textChangedCreateRecipe(sender: AnyObject) {
        let textField = sender as! UITextField
        var resp : UIResponder = textField
        while !(resp is UIAlertController) {
            resp = resp.nextResponder()!
        }
        let alert = resp as! UIAlertController
        (alert.actions[0]).enabled = (textField.text != "")
        if alert.actions[0] == true {
            (alert.actions[0]).enabled = checkRecipeTitleUnique(textField.text!)
        }
    }
    
    func textChangedEditRecipe(sender: AnyObject) {
        let textField = sender as! UITextField
        var resp : UIResponder = textField
        while !(resp is UIAlertController) {
            resp = resp.nextResponder()!
        }
        let alert = resp as! UIAlertController
        (alert.actions[0]).enabled = (textField.text != "")
    }
    
    // MARK: Helper Functions
    
    func checkRecipeTitleUnique(newRecipeName: String) -> Bool {
        for recipe in tableData {
            if recipe.title == newRecipeName {
                return false
            }
        }
        return true
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
    
    // Display a prompt with the given title and message
    func displayConfirmDialog(title: String, message: String) {
        dispatch_async(dispatch_get_main_queue(), {
            let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                
            }))
            let subview = refreshAlert.view.subviews.first! as UIView
            let alertContentView = subview.subviews.first! as UIView
            alertContentView.backgroundColor = UIColor.whiteColor()
            alertContentView.tintColor = UIColor.darkGrayColor()
            self.presentViewController(refreshAlert, animated: true, completion: nil)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
