//
//  Router.swift
//  Delivery
//
//  Created by Hemant Singh on 26/07/19.
//  Copyright © 2019 Hemant Singh. All rights reserved.
//

import UIKit

protocol Router {
    func route(
        to routeID: String,
        from context: UIViewController,
        parameters: Any?
    )
}
