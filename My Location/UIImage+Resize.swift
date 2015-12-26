//
//  UIImage+Resize.swift
//  My Location
//
//  Created by Van Luu on 13/11/2015.
//  Copyright © 2015 Van Luu. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func resizedImageWithBounds(bound: CGSize) -> UIImage {
        let horizontalRatio = bound.width / size.width
        let verticalRatio = bound.height / size.height
        let ratio = min(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        drawInRect(CGRect(origin: CGPoint.zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}