//
//  CollectionExtension.swift
//  Delivery
//
//  Created by Hemant Singh on 28/07/19.
//  Copyright © 2019 Hemant Singh. All rights reserved.
//

import Foundation

extension Collection {
    public subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
