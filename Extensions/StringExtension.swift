//
//  StringExtension.swift
//  Delivery
//
//  Created by Hemant Singh on 26/07/19.
//  Copyright © 2019 Hemant Singh. All rights reserved.
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
