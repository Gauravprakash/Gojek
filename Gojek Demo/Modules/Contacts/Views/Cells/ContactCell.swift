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
        imgView.clipsToBounds = true
        return imgView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(nameLabel)
        self.addSubview(nameImageView)
        nameImageView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(cellHeight - CGFloat(2 * margin))
            make.height.equalTo(cellHeight - CGFloat(2 * margin))
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
    }
    
    func bind(with contact: ContactListing) {
        if let fname = contact.firstName, let lname = contact.lastName{
            nameLabel.text = "\(fname) \(lname)"
        }
        if let urlString = contact.url, let imageUrl = URL(string: urlString) {
            nameImageView.kf.setImage(with: imageUrl)
        }
        else{
            nameImageView.image = UIImage()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
