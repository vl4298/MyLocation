//
//  MyTabBarController.swift
//  My Location
//
//  Created by Van Luu on 14/11/2015.
//  Copyright © 2015 Van Luu. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func childViewControllerForStatusBarStyle() -> UIViewController? {
        return nil
    }
}
