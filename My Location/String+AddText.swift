//
//  String+AddText.swift
//  My Location
//
//  Created by Van Luu on 14/11/2015.
//  Copyright © 2015 Van Luu. All rights reserved.
//

import Foundation

extension String {
    mutating func addText(text: String?, withSeparator separator: String = "") {
        if let text = text {
            if !isEmpty {
                self += separator
            }
            self += text
        }
    }
}
