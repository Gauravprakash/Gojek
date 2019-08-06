//
//  ViewController.swift
//  Gojek Demo
//
//  Created by Hemant Singh on 05/08/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import UIKit
import Toast_Swift
import DZNEmptyDataSet

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    var viewModel = ContactListViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        if viewModel.contactArray.count == 0 {
            viewModel.fetchContacts()
        }
    }
    
    func setupBindings(){
        viewModel.fetchContacts()
        viewModel.onError = { [weak self] (error) in
            self?.view.makeToast(error.localizedDescription)
        }
        self.tableView.reloadData()
//        viewModel.onData = {[weak self] _ in
//            self?.tableView.reloadData()
//        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
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




extension ViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
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


