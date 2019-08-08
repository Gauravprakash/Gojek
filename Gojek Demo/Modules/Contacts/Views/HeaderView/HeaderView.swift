//
//  HeaderView.swift
//  Gojek Demo
//
//  Created by Gaurav Prakash on 07/08/19.
//  Copyright © 2019 Gaurav. All rights reserved.
//

import UIKit
import Kingfisher
import Moya


class HeaderView: UIView {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var favButton: UIButton!
    
    var apiProvider: MoyaProvider<API> = APIProvider
    var onError: ((Error) -> Void)?
    public var callback : (Int, Bool) -> () = {_, _ in}
    
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
            self.userName.text = fname + " " + lname
        }
        self.favButton.isSelected = contact.favorite ?? false
        
    }

    @IBAction func sendActions(_ sender: UIButton) {
        switch sender.tag {
        case 100:
            sender.isSelected = !sender.isSelected
            callback(sender.tag, sender.isSelected)
        case 97,98,99:
            callback(sender.tag, false)
        default:
            break
        }
    }
    
    
    public func setFavouriteContact(){
        //apiProvider.request(API.CONTACTDETAILS(<#T##Int#>), completion: <#T##Completion##Completion##(Result<Response, MoyaError>) -> Void#>)
    }
    
    
    
}
