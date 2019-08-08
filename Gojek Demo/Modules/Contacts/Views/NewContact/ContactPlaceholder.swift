//
//  ContactPlaceholder.swift
//  Gojek Demo
//
//  Created by Hemant Singh on 08/08/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import UIKit

class ContactPlaceholder: UIView {
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var cameraBtn: UIButton!
    
    class func instanceFromNib() -> ContactPlaceholder{
        return UINib(nibName: "ContactPlaceholder", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ContactPlaceholder
    }
}
