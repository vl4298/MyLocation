//
//  CategoryPickerViewController.swift
//  My Location
//
//  Created by Van Luu on 09/11/2015.
//  Copyright © Năm 2015 Van Luu. All rights reserved.
//

import UIKit

class CategoryPickerViewController: UITableViewController {
    
    var selectedCategory = ""
    
    var categories = ["No Category", "Apple Store", "Bar", "Bookstore", "Club",
        "Grocery Store", "Historic Building", "House",
        "Icecream Vendor", "Landmark",
        "Park"]
    
    var selectedIndexPath = NSIndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0..<categories.count {
            if categories[i] == selectedCategory {
                selectedIndexPath = NSIndexPath(forRow: i, inSection: 0)
                break
            }
        }
        
        tableView.backgroundColor = UIColor.blackColor()
        tableView.separatorColor = UIColor(white: 1.0, alpha: 0.2)
        tableView.indicatorStyle = .White
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let categoryName = categories[indexPath.row]
        cell.textLabel?.text = categoryName
        
        if categoryName == selectedCategory {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row != selectedIndexPath.row {
            if let newCell = tableView.cellForRowAtIndexPath(indexPath) {
                newCell.accessoryType = .Checkmark
            }
            
            if let oldCell = tableView.cellForRowAtIndexPath(selectedIndexPath) {
                oldCell.accessoryType = .None
            }
            
            selectedIndexPath = indexPath
            
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.blackColor()
        
        if let textLabel = cell.textLabel {
            textLabel.textColor = UIColor.whiteColor()
            textLabel.highlightedTextColor = textLabel.textColor
        }
        
        let selectionView = UIView(frame: CGRect.zero)
        selectionView.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        cell.selectedBackgroundView = selectionView
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PickedCategory" {
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPathForCell(cell) {
                selectedCategory = categories[indexPath.row]
            }
        }
    }
}
