//
//  DensityDatabaeViewController.swift
//  final_project
//
//  Created by JT Newsome on 5/2/16.
//  Copyright © 2016 JT Newsome. All rights reserved.
//

import UIKit

protocol RecipeManagerDelegate3: class {
    
    func sendDataToRecipeManager3(sender: DensityDatabaseViewController, ingredient: Ingredient, index: Int)
}

class DensityDatabaseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, DensityDatabaseDelegate {
    
    var ingredient: Ingredient?
    var index: Int?
    var sender: RecipeManagerViewController?
    
    var validAmount: Bool = false
    var validTitle: Bool = false
    
    var tableData: [Density] = []
    var filteredTableData = [Density]()
    var tableView: UITableView = UITableView()
    var resultSearchController = UISearchController(searchResultsController: nil)
    
    var delegate:RecipeManagerDelegate3? = nil
    
    private var densityDBView: DensityDatabaseView! {
        return (view as! DensityDatabaseView)
    }
    
    override func loadView() {
        view = DensityDatabaseView(frame: CGRectZero)
        
        print("Loaded: DensityDatabaseViewController")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "Density DB"
        
        self.automaticallyAdjustsScrollViewInsets = false
        let recipeListRect = CGRectMake(0, 64, UIScreen.mainScreen().bounds.width, 454)
        tableView.frame = recipeListRect
        tableView.backgroundColor = UIColor.clearColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(DensityDatabaseViewController.clickedAddButton))
        
        resultSearchController.searchBar.sizeToFit()
        resultSearchController.searchResultsUpdater = self
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.searchBar.barTintColor = UIColor(hue: 0, saturation: 0, brightness: 0.8, alpha: 0.1)
        resultSearchController.searchBar.tintColor = UIColor.blueColor()
        resultSearchController.searchBar.showsCancelButton = false
        tableView.tableHeaderView = resultSearchController.searchBar
        tableView.addSubview(resultSearchController.searchBar)
        
        tableView.showsVerticalScrollIndicator = true
        tableView.scrollEnabled = true
        tableView.bounces = true
        tableView.separatorStyle = .None
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(DensityTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(DensityTableViewCell))
        
        view.addSubview(tableView)
        
        loadData()
    }
    
    // MARK: Save/Load
    func saveData() {
        let data = NSKeyedArchiver.archivedDataWithRootObject(tableData)
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let filename = paths[0].stringByAppendingString("densities.txt")
        data.writeToFile(filename, atomically: true)
    }
    
    func loadData() {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let filename = paths[0].stringByAppendingString("densities.txt")
        if let data = NSKeyedUnarchiver.unarchiveObjectWithFile(filename) as? [Density] {
            tableData = data
        }
    }
    
    func clearData() {
        tableData = []
        saveData()
    }
    
    // MARK: Button Listeners
    func clickedAddButton() {
        print("Clicked Add Button!")
        
        var titleField: UITextField!
        var densityField: UITextField!
        
        // Make a Create Recipe Alert Modal
        let refreshAlert = UIAlertController(title: "NEW DENSITY", message: "Give a title and specify how many grams per cup there are for this item.", preferredStyle: UIAlertControllerStyle.Alert)
        
        // Title Input
        refreshAlert.addTextFieldWithConfigurationHandler({ (textField: UITextField!) in
            textField.addTarget(self, action: #selector(DensityDatabaseViewController.textChangedTitle(_:)), forControlEvents: .EditingChanged)
            titleField = textField
            titleField.placeholder = "Title"
        })
        
        // Density Input
        refreshAlert.addTextFieldWithConfigurationHandler({ (textField: UITextField!) in
            textField.addTarget(self, action: #selector(DensityDatabaseViewController.textChangedAmount(_:)), forControlEvents: .EditingChanged)
            densityField = textField
            densityField.placeholder = "Grams per Cup"
            
            densityField.keyboardType = .NumberPad
        })
        
        // Create Button
        refreshAlert.addAction(UIAlertAction(title: "Create", style: .Default, handler: { (action: UIAlertAction!) in
            let density: Int = Int(densityField.text!)!
            let title: String = titleField.text!
            let newDensity: Density = Density(title: title, density: density)
            self.tableData.append(newDensity)
            
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
    
    // MARK: Receive Data
    // Called when we get data from RecipeManager
    func sendDataToDensityDatabaseViewController(sender: RecipeManagerViewController, ingredient: Ingredient, index: Int) {
        print("Got data from RecipeManager")
        self.ingredient = ingredient
        self.index = index
        self.sender = sender
    }
    
    // MARK: Table: Recipe List
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(DensityTableViewCell), forIndexPath: indexPath) as! DensityTableViewCell
        
        cell.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.9, alpha: 0.7)
        
        cell.selectionStyle = .None
        cell.accessoryType = .DisclosureIndicator
        
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        if (self.resultSearchController.active) {
            cell.density = filteredTableData[indexPath.section]
            cell.titleLabel.text = filteredTableData[indexPath.section].title
            cell.densityLabel.text = String(filteredTableData[indexPath.section].density)
            return cell
        }
        else {
            cell.density = tableData[indexPath.section]
            cell.titleLabel.text = tableData[indexPath.section].title
            cell.densityLabel.text = "\(String(tableData[indexPath.section].density))g / Cup"
            return cell
        }
    }
    
    // Do When Selects a Row
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("Clicked: \(tableData[indexPath.section].title)")
        
        self.delegate = sender
        self.delegate?.sendDataToRecipeManager3(self, ingredient: self.ingredient!, index: self.index!)
        self.navigationController?.popViewControllerAnimated(true)
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
        return 7
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
        filteredTableData = array as! [Density]
        
        // Don't count empty search as a constraint (which would always return nothing)
        if searchController.searchBar.text == "" {
            filteredTableData = tableData
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: Text Changes
    func textChangedTitle(sender: AnyObject) {
        let textField = sender as! UITextField
        var resp : UIResponder = textField
        while !(resp is UIAlertController) {
            resp = resp.nextResponder()!
        }
        let alert = resp as! UIAlertController
        validTitle = ((alert.actions[0]) != "")
        if validAmount == true && validTitle == true {
            (alert.actions[0]).enabled = true
        }
        else {
            (alert.actions[0]).enabled = false
        }
    }
        
    func textChangedAmount(sender: AnyObject) {
        let textField = sender as! UITextField
        var resp : UIResponder = textField
        while !(resp is UIAlertController) {
            resp = resp.nextResponder()!
        }
        let alert = resp as! UIAlertController
        
        validAmount = (textField.text != "")
        if validAmount == true {
            var badCount = 0
            var goodCount = 0
            for char in textField.text!.characters {
                if char > "9" || char < "0" {
                    badCount += 1
                }
                else {
                    goodCount += 1
                }
            }
            if badCount > 0 || goodCount <= 0 {
                validAmount = false
            }
            else {
                validAmount = true
            }
        }
        if validAmount == true && validTitle == true {
            (alert.actions[0]).enabled = true
        }
        else {
            (alert.actions[0]).enabled = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
