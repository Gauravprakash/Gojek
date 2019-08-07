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

enum Route: String {
    case deliveryDetails
}

class ContactListViewController: UIViewController {
 
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
    //var router = DeliveryListRouter()
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.contactArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  let cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.reuseIdentifier, for: indexPath)
            as? ContactCell {
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let contact = viewModel.contactArray?[safe: indexPath.row] {
            (cell as? ContactCell)?.bind(with: contact)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //router.route(to: Route.deliveryDetails.rawValue, from: self, parameters: viewModel.deliveryArray[safe: indexPath.row])
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
