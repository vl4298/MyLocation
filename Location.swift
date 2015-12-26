//
//  Location.swift
//  My Location
//
//  Created by Van Luu on 09/11/2015.
//  Copyright © Năm 2015 Van Luu. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class Location: NSManagedObject, MKAnnotation {

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(latitude, longtitude)
    }
    
    var title: String? {
        if locationDescription.isEmpty {
            return "(No Description)"
        } else {
            return locationDescription
        }
    }
    
    var subtitle: String? {
        return category
    }
    
    var hasPhoto: Bool {
        return photoID != nil
    }
    
    var photoPath: String {
        assert(photoID != nil, "No Photo ID set")
        let fileName = "Photo-\(photoID!.integerValue).jpg"
        return (applicationDocumentsDiretory as NSString).stringByAppendingPathComponent(fileName)
    }
    
    var photoImage: UIImage? {
        return UIImage(contentsOfFile: photoPath)
    }
    
    func removeFilePath() {
        if hasPhoto {
            let path = photoPath
            let fileManager = NSFileManager.defaultManager()
            if fileManager.fileExistsAtPath(path) {
                do {
                    try fileManager.removeItemAtPath(path)
                } catch {
                    print("Error removing file: \(error)")
                }
            }
        }
    }
    
    class func nextPhotoID() -> Int{
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let currentID = userDefaults.integerForKey("PhotoID")
        userDefaults.setInteger(currentID + 1, forKey: "PhotoID")
        userDefaults.synchronize()
        return currentID
    }
}
