//
//  Functions.swift
//  My Location
//
//  Created by Van Luu on 09/11/2015.
//  Copyright © Năm 2015 Van Luu. All rights reserved.
//

import Foundation
import Dispatch
import UIKit

func afterDelay(second: Double, closure: () -> ()) {
    let when = dispatch_time(DISPATCH_TIME_NOW, Int64(second * Double(NSEC_PER_SEC)))
    
    dispatch_after(when, dispatch_get_main_queue(), closure)
}

let applicationDocumentsDiretory: String = {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    return paths[0]
}()
