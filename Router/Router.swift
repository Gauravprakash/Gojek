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


struct ContactListRouter: Router {
    
    func route(to routeID: String, from context: UIViewController, parameters: Any?) {
        guard let route = ContactListViewController.Route(rawValue: routeID) else {
            return
        }
        switch route {
        case .contactDetails:
            guard let contact = parameters as? Contact else {
                return
            }
            let destinationVC = ContactDetailViewController()
            let deliveryDetailsVM = ContactDetailViewModel(model: contact)
            destinationVC.viewModel = deliveryDetailsVM
            context.navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
}
