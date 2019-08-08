//
//  StringExtension.swift
//  Gojek Demo
//
//  Created by Gaurav Prakash on 07/08/19.
//  Copyright © 2019 Gaurav. All rights reserved.
//

import UIKit

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    var attributedString: NSAttributedString {
        return NSAttributedString(string: self)
    }
}
