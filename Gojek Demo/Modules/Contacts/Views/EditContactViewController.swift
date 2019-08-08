//
//  EditContactViewController.swift
//  Gojek Demo
//
//  Created by Hemant Singh on 05/08/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import UIKit
import Moya
import Alamofire

enum ViewManager{
    case EditContact
    case NewContact
}

class EditContactViewController: UIViewController {
    var model:Contact?
    var data = ContactData()
    var apiProvider: MoyaProvider<API> = APIProvider
    var onError: ((Error) -> Void)?
    var manager:ViewManager! = ViewManager.NewContact
    weak var delegate:ChangeContactDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
     }
    
    lazy var contactTableView: UITableView = {
        let table = UITableView(frame: self.view.frame, style: .plain)
        table.dataSource = self
        table.delegate = self
        table.tableFooterView = UIView()
        table.separatorColor = .clear
        table.registerNibs(nibNames: ["EditFieldCell"])
        return table
    }()
    
    private func setUpView(){
        if let dataSource = model{
            data = ContactData(contact: dataSource)
        }
        self.view.addSubview(contactTableView)
        contactTableView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
            make.height.equalTo(self.view)
            make.center.equalTo(self.view)
        }
        let cancelItem =  UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(self.dismissController))
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action:#selector(self.createRawRequest))
        [cancelItem, doneItem].forEach {(
            $0.tintColor = Color.buttonColor
            )}
        self.navigationItem.rightBarButtonItem = doneItem
        self.navigationItem.leftBarButtonItem = cancelItem
        self.navigationItem.hidesBackButton = true
    }
    
    @objc private func dismissController(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func createRawRequest() {
        if data.validateData().0 == true{
           let jsonData = try? JSONSerialization.data(withJSONObject: data.toDictionary(), options: [])
           let jsonString = String(data: jsonData!, encoding: .utf8)
           let data = (jsonString?.data(using: .utf8))! as Data
            switch manager! {
            case .EditContact:
                if let contact = model, let id = contact.id{
                    let jsonObject = (id, data)
                    apiProvider.request(API.UPDATECONTACT(jsonObject)) { [weak self] (result) in
                        switch result {
                        case .success:
                            self?.delegate.changeContactModel(contact: contact)
                            self?.navigationController?.popViewController(animated: true)
                        case .failure(let error):
                            self?.view.makeToast("\(error.localizedDescription)")
                        }
                    }
                }
              
            case .NewContact:
                apiProvider.request(API.NEWCONTACT(data)) { [weak self] (result) in
                    switch result {
                    case .success:
                        self?.view.makeToast("Contact created successfully")
                        self?.navigationController?.popViewController(animated: true)
                    case .failure(let error):
                        self?.view.makeToast("\(error.localizedDescription)")
                    }
                }
            }
    }
        else{
            self.view.makeToast(data.validateData().1)
        }
    }

}

extension EditContactViewController:UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? 1 : 4
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section == 0) ? 200 : 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            return UITableView.automaticDimension
        default:
            return  0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section{
        case 0 :
            let header = ContactPlaceholder.instanceFromNib()
            return header
        default:
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 1:
        if  let cell = tableView.dequeueReusableCell(withIdentifier: EditFieldCell.reuseIdentifier, for: indexPath)
            as? EditFieldCell {
            cell.index = indexPath.row
            cell.completionCallback = { [weak self]  index, text in
                switch index {
                case 0:
                    self?.data.firstname = text
                case 1:
                    self?.data.lastname = text
                case 2:
                    self?.data.mobile = text
                case 3:
                    self?.data.email = text
                default:
                    break
                }
                
                
            }
            return cell
        }
        default:
         return UITableViewCell()
        }
    return UITableViewCell()
}
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? EditFieldCell{
            switch indexPath.row {
            case 0:
                cell.textField.placeholder = "First Name"
                if let fname = model?.firstName{
                    cell.textField.text = fname
                }
            case 1:
                cell.textField.placeholder = "Last Name"
                if let lname = model?.lastName{
                    cell.textField.text = lname
                }
            case 2:
                cell.textField.placeholder = "Mobile"
                if let mobile = model?.phoneNumber{
                    cell.textField.text = mobile
                }
            case 3:
                cell.textField.placeholder = "Email"
                if let email = model?.emailId{
                   cell.textField.text = email
                }
            default:
                break
            }
        }
    }
    
}

