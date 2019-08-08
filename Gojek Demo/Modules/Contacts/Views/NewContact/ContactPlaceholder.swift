//
//  ContactPlaceholder.swift
//  Gojek Demo
//
//  Created by Gaurav Prakash on 07/08/19.
//  Copyright © 2019 Gaurav. All rights reserved.
//

import UIKit

class ContactPlaceholder: UIView {
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var cameraBtn: UIButton!
    
    class func instanceFromNib() -> ContactPlaceholder{
        return UINib(nibName: "ContactPlaceholder", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ContactPlaceholder
    }
}
