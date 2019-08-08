//
//  ContactListViewController.swift
//  Gojek Demo
//
//  Created by Gaurav Prakash on 07/08/19.
//  Copyright © 2019 Gaurav. All rights reserved.
//

import UIKit
import Toast_Swift
import DZNEmptyDataSet



class ContactListViewController: UIViewController {
    
    enum Route: String {
        case contactDetails
        case editContact
    }

    lazy var contactTableView: UITableView = {
        let table = UITableView(frame: self.view.frame, style: .plain)
        table.estimatedRowHeight = 100
        table.dataSource = self
        table.delegate = self
        table.emptyDataSetSource = self
        table.emptyDataSetDelegate = self
        table.rowHeight = UITableView.automaticDimension
        table.tableFooterView = UIView()
        table.register(ContactCell.self, forCellReuseIdentifier: ContactCell.reuseIdentifier)
        return table
    }()
    
    var viewModel = ContactListViewModel()
    var router = ContactListRouter()
    
    override func loadView() {
        super.loadView()
        let groupItem = UIBarButtonItem(title: "Groups", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        let addItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(self.addContact))
        [groupItem, addItem].forEach {(
            $0.tintColor = Color.buttonColor
        )}
        self.navigationItem.rightBarButtonItem = addItem
        self.navigationItem.leftBarButtonItem = groupItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Contacts"

       self.view.addSubview(contactTableView)
        contactTableView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
            make.height.equalTo(self.view)
            make.center.equalTo(self.view)
        }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupBindings()
        if viewModel.contactArray.count == 0 {
            viewModel.fetchContacts()
        }
    }
    
 func setupBindings(){
            viewModel.contactArray = []
            viewModel.onError = { [weak self] (error) in
                self?.view.makeToast(error.localizedDescription)
            }
            viewModel.onData = {[weak self] _ in
                self?.contactTableView.reloadData()
            }
        }
    
    @objc private func addContact(){
       self.router.route(to: Route.editContact.rawValue, from: self, parameters: nil)
    }
}

extension ContactListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.contactDictionary.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.contactDictionary[viewModel.keys[section]]?.count ?? 0

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  let cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.reuseIdentifier, for: indexPath)
            as? ContactCell {
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let key = viewModel.keys[indexPath.section]
        if let contact = viewModel.contactDictionary[key]?[indexPath.row] {
           (cell as? ContactCell)?.bind(with: contact)
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { //You can use viewForHeaderInSection either.
        return viewModel.keys[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let contact = viewModel.contactDictionary[viewModel.keys[indexPath.section]]?[indexPath.row], let id = contact.id{
            viewModel.loadContactDetail(id: id) { (contact) in
                self.router.route(to: Route.contactDetails.rawValue, from: self, parameters: contact)
            }
            
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return viewModel.alphabets
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                if let contact = viewModel.contactDictionary[viewModel.keys[indexPath.section]]?[indexPath.row], let id = contact.id {
                    self.viewModel.deleteContact(id: id) { [weak self] (done) in
                        if done ?? false{
                            self?.viewModel.contactArray = []
                            self?.viewDidLoad()
                        }
                    }
                }

            } else if editingStyle == .insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
            }
        
    }

}




extension ContactListViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return AppStrings.noData.attributedString
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return AppStrings.pullToRefresh.attributedString
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}
