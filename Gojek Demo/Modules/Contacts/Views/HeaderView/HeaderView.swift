//
//  HeaderView.swift
//  Gojek Demo
//
//  Created by Hemant Singh on 07/08/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import UIKit
import Kingfisher

class HeaderView: UIView {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    public var callback : (Int) -> () = {_ in}
    
    class func instanceFromNib() -> HeaderView{
    return UINib(nibName: "HeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! HeaderView
   }
    func bindData(contact:Contact){
        if let urlString = contact.profilePic, let imageUrl = URL(string: Theme.baseUrl + urlString) {
            imgView.kf.setImage(with: imageUrl)
        }
        else{
            imgView.image = UIImage()
        }
        if let fname = contact.firstName, let lname = contact.lastName{
            self.userName.text = fname + lname
        }
    }

    @IBAction func sendActions(_ sender: UIButton) {
        switch sender.tag {
        case 100:
            sender.isSelected = !sender.isSelected
        default:
            break
        }
        callback(sender.tag)
    }
    
}
