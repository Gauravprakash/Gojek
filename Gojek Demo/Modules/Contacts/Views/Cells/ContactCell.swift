//
//  ContactCell.swift
//  Gojek Demo
//
//  Created by Hemant Singh on 05/08/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class ContactCell: UITableViewCell {
    static let reuseIdentifier = "ContactCell"
    let margin = 8
    let cellHeight: CGFloat = 100
    
    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let nameImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.kf.indicatorType = IndicatorType.activity
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    private let favImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.kf.indicatorType = IndicatorType.activity
        imgView.contentMode = .scaleAspectFill
        imgView.image = UIImage(named: "home_favourite")
        return imgView
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.addSubview(nameLabel)
        self.addSubview(nameImageView)
        self.addSubview(favImageView)
        nameImageView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(cellHeight - CGFloat(2 * 30))
            make.height.equalTo(cellHeight - CGFloat(2 * 30))
            make.top.equalTo(self).offset(margin)
            make.left.equalTo(self).offset(margin)
            make.bottom.equalTo(self).offset(-margin)
        }
        nameLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(margin)
            make.left.equalTo(nameImageView.snp.right).offset(margin)
            make.right.equalTo(self).offset(-margin)
            make.height.equalTo(60)
        }
        favImageView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-30)
        }
   }
    
    func bind(with contact: Contact) {
        if let fname = contact.firstName, let lname = contact.lastName{
            nameLabel.text = "\(fname) \(lname)"
        }
        
        if let urlString = contact.profilePic, let imageUrl = URL(string: Theme.baseUrl + urlString) {
            nameImageView.kf.setImage(with: imageUrl)
        }
        else{
            nameImageView.image = UIImage()
        }
        favImageView.isHidden = !(contact.favorite ?? false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
