//
//  LocationsViewController.swift
//  My Location
//
//  Created by Van Luu on 10/11/2015.
//  Copyright © Năm 2015 Van Luu. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class LocationsViewController: UITableViewController {
    
    var managedObjectContext: NSManagedObjectContext?
    lazy var fetchedResultController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest()
        
        let entity = NSEntityDescription.entityForName("Location", inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity
        
        let sortDescriptor1 = NSSortDescriptor(key: "category", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor2]
        
        fetchRequest.fetchBatchSize = 20
        
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: "category", cacheName: "Locations")
        
        fetchedResultController.delegate = self
        return fetchedResultController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //NSFetchedResultsController.deleteCacheWithName("Locations")
        navigationItem.rightBarButtonItem = editButtonItem()
        performFetch()
        
        tableView.backgroundColor = UIColor.blackColor()
        tableView.separatorColor = UIColor(white: 1.0, alpha: 0.2)
        tableView.indicatorStyle = .White
    }
    
    func performFetch() {
        do {
            try fetchedResultController.performFetch()
        } catch {
            fatalCoreDataError(error)
        }
    }
    
    deinit {
        fetchedResultController.delegate = nil
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultController.sections!.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = fetchedResultController.sections![section]
        return sectionInfo.name.uppercaseString
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LocationCell", forIndexPath: indexPath) as! LocationCell
        let location = fetchedResultController.objectAtIndexPath(indexPath) as! Location
        
        cell.configureForLocation(location)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let location = fetchedResultController.objectAtIndexPath(indexPath) as! Location
            location.removeFilePath()
            managedObjectContext?.deleteObject(location)
            
            do {
                try managedObjectContext?.save()
            } catch {
                fatalCoreDataError(error)
            }
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let labelRect = CGRect(x: 15, y: tableView.sectionHeaderHeight - 14, width: 300, height: 14)
        
        let label = UILabel(frame: labelRect)
        label.font = UIFont.boldSystemFontOfSize(11)
        
        label.text = tableView.dataSource!.tableView!(tableView, titleForHeaderInSection: section)
        
        label.textColor = UIColor(white: 1.0, alpha: 0.4)
        label.backgroundColor = UIColor.clearColor()
        
        let separatorRect = CGRect(x: 15, y: tableView.sectionHeaderHeight - 0.5, width: tableView.bounds.size.width - 15, height: 0.5)
        let separator = UIView(frame: separatorRect)
        separator.backgroundColor = tableView.separatorColor
        
        let viewRect = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.sectionHeaderHeight)
        
        let view = UIView(frame: viewRect)
        view.backgroundColor = UIColor(white: 0, alpha: 0.85)
        view.addSubview(label)
        view.addSubview(separator)
        
        return view
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditLocation" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! LocationDetailViewController
            controller.managedObjectContext = managedObjectContext
            
            if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                let location = fetchedResultController.objectAtIndexPath(indexPath) as! Location
                controller.locationToEdit = location
            }
        }
    }
}

extension LocationsViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        print("****** controllerWillChangeContent")
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            print("******* NSFetchedResultChangeInsert (Object)")
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            print("******* NSFetchedResultChangeDelete (Object)")
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            print("******* NSFetchedResultChangeUpdate (Object)")
            if let cell = tableView.cellForRowAtIndexPath(indexPath!) as? LocationCell {
                let location = controller.objectAtIndexPath(indexPath!) as! Location
                cell.configureForLocation(location)
            }
        case .Move:
            print("******* NSFetchedResultChangeMove (Object)")
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            print("*** NSFetchedResultChangeInsert (section)")
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            print("*** NSFetchedResultChangeDelete (section)")
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Update:
            print("*** NSFetchedResultChangeUpdate (section)")
        case .Move:
            print("*** NSFetchedResultChangeMove (section)")
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        print("******* controllerDidChangeContent")
        tableView.endUpdates()
    }
}