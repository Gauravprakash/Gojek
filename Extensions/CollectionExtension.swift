//
//  CollectionExtension.swift
//  Delivery
//
//  Created by Hemant Singh on 28/07/19.
//  Copyright © 2019 Hemant Singh. All rights reserved.
//

import Foundation
import UIKit

extension Collection {
    public subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
  
}

extension UITableView {
    func registerNibs(nibNames nibs: [String]) {
        for nib in nibs {
            let cellNib = UINib(nibName: nib, bundle: nil)
            register(cellNib, forCellReuseIdentifier: nib)
        }
    }
}


extension UIImageView{
    func createRoundImage(){
    self.layer.borderWidth = 1.0
    self.layer.masksToBounds = false
    self.layer.borderColor = UIColor.white.cgColor
    self.layer.cornerRadius = self.frame.size.width / 2
    self.clipsToBounds = true
    }
}
