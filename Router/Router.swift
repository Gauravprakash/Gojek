//
//  Router.swift
//  Gojek Demo
//
//  Created by Gaurav Prakash on 07/08/19.
//  Copyright © 2019 Gaurav. All rights reserved.
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
            
        case .editContact:
            let destinationVC = EditContactViewController()
            destinationVC.model = parameters as? Contact
            if let _ = parameters as? Contact{
              destinationVC.delegate = (context as? ContactDetailViewController)
              destinationVC.manager = ViewManager.EditContact
            }
            else{
                destinationVC.manager = ViewManager.NewContact
            }
            context.navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
}
