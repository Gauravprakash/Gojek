//
//  ContactListViewController.swift
//  Gojek Demo
//
//  Created by Hemant Singh on 05/08/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import UIKit
import Toast_Swift
import DZNEmptyDataSet


class ContactListViewController: UIViewController {
    
    enum Route: String {
        case contactDetails
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
        let addItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: nil)
        [groupItem, addItem].forEach {(
            $0.tintColor = Color.buttonColor
        )}
        self.navigationItem.rightBarButtonItem = addItem
        self.navigationItem.leftBarButtonItem = groupItem
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Contacts Found"

       self.view.addSubview(contactTableView)
        contactTableView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
            make.height.equalTo(self.view)
            make.center.equalTo(self.view)
        }
        setupBindings()
        if viewModel.contactArray.count == 0 {
            viewModel.fetchContacts()
        }
    }
    
 func setupBindings(){
            viewModel.onError = { [weak self] (error) in
                self?.view.makeToast(error.localizedDescription)
            }
            viewModel.onData = {[weak self] _ in
                self?.contactTableView.reloadData()
            }
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
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentSize.height > 0 && scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height {
//            if !viewModel.isLoading && !viewModel.isLoadingNextPage && viewModel.hasMore {
//                viewModel.fetchNextPage()
//            }
//        }
//    }
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
