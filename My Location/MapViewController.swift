//
//  MapViewController.swift
//  My Location
//
//  Created by Van Luu on 12/11/2015.
//  Copyright © 2015 Van Luu. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    // "didSet" tp update new annotation when user edit information or add new locations
    // fetchRequest only does once when view is loaded
    var managedObjectContext: NSManagedObjectContext! {
        didSet {
            NSNotificationCenter.defaultCenter().addObserverForName(NSManagedObjectContextObjectsDidChangeNotification, object: managedObjectContext, queue: NSOperationQueue.mainQueue(), usingBlock: { notification in
                if self.isViewLoaded() {
                    self.updateLocations()
                }
            })
        }
    }

    var locations = [Location]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLocations()
        
        if !locations.isEmpty {
            showLocation()
        }
    }
    
    @IBAction func showUser() {
        let region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 1000, 1000)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }
    
    @IBAction func showLocation() {
        let region = regionForAnnotations(locations)
        mapView.setRegion(region, animated: true)
    }
    
    func updateLocations() {
        mapView.removeAnnotations(locations)
        
        let entity = NSEntityDescription.entityForName("Location", inManagedObjectContext: managedObjectContext)
        
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        
        locations = try! managedObjectContext.executeFetchRequest(fetchRequest) as! [Location]
        mapView.addAnnotations(locations)
    }
    
    // calculate the appropiate view for all location(annotation)
    // return region fits all!!
    func regionForAnnotations(annotations: [MKAnnotation]) -> MKCoordinateRegion{
        var region: MKCoordinateRegion
        
        switch annotations.count {
        case 0:
            region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 1000, 1000)
        case 1:
            let annotation = annotations[annotations.count - 1]
            region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 1000, 1000)
        default:
            var topLeftCoor = CLLocationCoordinate2DMake(-90, 180)
            var bottomRightCoor = CLLocationCoordinate2DMake(90, -180)
            
            for annotaion in annotations {
                topLeftCoor.latitude = max(topLeftCoor.latitude, annotaion.coordinate.latitude)
                topLeftCoor.longitude = min(topLeftCoor.longitude, annotaion.coordinate.longitude)
                
                bottomRightCoor.latitude = min(bottomRightCoor.latitude, annotaion.coordinate.latitude)
                bottomRightCoor.longitude = max(bottomRightCoor.longitude, annotaion.coordinate.longitude)
            }
            
            let center = CLLocationCoordinate2D(latitude: topLeftCoor.latitude - (topLeftCoor.latitude - bottomRightCoor.latitude)/2, longitude: topLeftCoor.longitude - (topLeftCoor.longitude - bottomRightCoor.longitude)/2)
            let extraSpace = 1.1
            let span = MKCoordinateSpan(latitudeDelta: abs(topLeftCoor.latitude - bottomRightCoor.latitude) * extraSpace, longitudeDelta: abs(topLeftCoor.longitude - bottomRightCoor.longitude) * extraSpace)
            
            region = MKCoordinateRegion(center: center, span: span)
        }
        return mapView.regionThatFits(region)
    }
    
    func showLocationDetails(sender: UIButton) {
        performSegueWithIdentifier("EditLocation", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditLocation" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! LocationDetailViewController
            
            controller.managedObjectContext = managedObjectContext
            let button = sender as! UIButton
            let location = locations[button.tag]
            
            controller.locationToEdit = location
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Location else {
            return nil
        }
        
        let identifier = "Location"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as! MKPinAnnotationView!
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            annotationView.tintColor = UIColor(white: 0.0, alpha: 5.5)
            annotationView.enabled = true
            annotationView.canShowCallout = true
            annotationView.animatesDrop = false
            annotationView.pinTintColor = UIColor(red: 0.32, green: 0.82, blue: 0.4, alpha: 1)
            
            let rightButton = UIButton(type: .DetailDisclosure)
            rightButton.addTarget(self, action: Selector("showLocationDetails:"), forControlEvents: .TouchUpInside)
            annotationView.rightCalloutAccessoryView = rightButton
        } else {
            let button = annotationView.rightCalloutAccessoryView as! UIButton
            if let index = locations.indexOf(annotation as! Location) {
                button.tag = index
            }
        }
        
        return annotationView
    }
}

// set navigation bar on top of the screen
extension MapViewController: UINavigationBarDelegate {
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}
