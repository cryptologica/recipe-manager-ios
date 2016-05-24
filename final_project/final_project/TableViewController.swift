//
//  TableViewController.swift
//  final_project
//
//  Created by JT Newsome on 4/23/16.
//  Copyright © 2016 JT Newsome. All rights reserved.
//

// TODO: DELETE - For reference only. Decided to make custom cells.

import UIKit

class TableViewController: UITableViewController, UISearchResultsUpdating {
    
    var tableData: [Recipe] = []
    var filteredTableData = [Recipe]()
    var resultSearchController = UISearchController(searchResultsController: nil)
    
    let rowHeight: CGFloat = 40
    let rowPadding: CGFloat = 7
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGrayColor()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.tableFooterView = HeaderView(frame: CGRectMake(0, rowPadding, 0, rowHeight))
        tableView.separatorStyle = .None
        resultSearchController.searchResultsUpdater = self
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.searchBar.sizeToFit()
        resultSearchController.hidesNavigationBarDuringPresentation = false
        tableView.tableHeaderView = resultSearchController.searchBar
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if (self.resultSearchController.active) {
            return self.filteredTableData.count
        }
        else {
            return self.tableData.count
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        // Add that arrow thing on the right to each cell
        cell.accessoryType = .DisclosureIndicator
        
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        if (self.resultSearchController.active) {
            cell.textLabel?.text = filteredTableData[indexPath.section].title
            
            return cell
        }
        else {
            cell.textLabel?.text = tableData[indexPath.section].title
            
            return cell
        }
    }
    
    // Row Height
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return rowHeight
    }
    
    // Set the spacing between sections
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return rowPadding
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return rowPadding
    }
    
    // Make the background color show through
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clearColor()
        return headerView
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        filteredTableData.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF.title CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (tableData as NSArray).filteredArrayUsingPredicate(searchPredicate)
        filteredTableData = array as! [Recipe]
        
        self.tableView.reloadData()
    }
    
}
