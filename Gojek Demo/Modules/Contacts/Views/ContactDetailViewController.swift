//
//  ContactDetailViewController.swift
//  Gojek Demo
//
//  Created by Hemant Singh on 05/08/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import UIKit
import SnapKit

class ContactDetailViewController: UIViewController {
   var viewModel:ContactDetailViewModel?
    
   lazy var contactTableView: UITableView = {
        let table = UITableView(frame: self.view.frame, style: .plain)
        table.estimatedRowHeight = 100
        table.dataSource = self
        table.delegate = self
        table.rowHeight = UITableView.automaticDimension
        table.tableFooterView = UIView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(contactTableView)
        contactTableView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
            make.height.equalTo(self.view)
            make.center.equalTo(self.view)
        }
    }

}

extension ContactDetailViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section{
        case 0 :
            let header = HeaderView.instanceFromNib()
            if let contact = viewModel?.contact{
                header.bindData(contact:contact)
            }
             return header
        default:
            return UIView()
        }
     }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ( section == 0) ? 400 :  0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:

            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "mobile \(viewModel?.contact.phoneNumber ?? "")"
            case 1:
                cell.textLabel?.text = "email \(viewModel?.contact.emailId ?? "" )"
            default:
                break
            }
        default:
            break
        }
    }
    
    
}
