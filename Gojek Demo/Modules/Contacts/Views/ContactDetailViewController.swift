//
//  ContactDetailViewController.swift
//  Gojek Demo
//
//  Created by Gaurav Prakash on 07/08/19.
//  Copyright © 2019 Gaurav. All rights reserved.
//

import UIKit
import SnapKit
import Moya
import MessageUI


class ContactDetailViewController: UIViewController {
   var viewModel:ContactDetailViewModel?
   var router = ContactListRouter()
   var apiProvider: MoyaProvider<API> = APIProvider
   var sourceModel = ContactListViewModel()
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
        let editItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.edit, target: self, action: #selector(self.navigateView))
        editItem.tintColor = Color.buttonColor
        self.navigationItem.rightBarButtonItem = editItem
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hitRequest()
    }
    
    func hitRequest(){
        if let model = viewModel?.contact{
            let data = ContactData(contact: model)
            let jsonData = try? JSONSerialization.data(withJSONObject: data.toDictionary(), options: [])
            let jsonString = String(data: jsonData!, encoding: .utf8)
            let jsonObject = (jsonString?.data(using: .utf8))! as Data
            if let id = model.id{
                let jsonQuery = (id, jsonObject)
                apiProvider.request(API.UPDATECONTACT(jsonQuery)) { [weak self] (result) in
                    switch result {
                    case .success:
                        print("success")
                    case .failure(let error):
                        self?.view.makeToast("\(error.localizedDescription)")
                    }
                }
                
            }
        }
    
    }
    
    @objc private func navigateView(){
        self.router.route(to: ContactListViewController.Route.editContact.rawValue,from: self, parameters: viewModel?.contact)
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
            header.callback = { [weak self] (tag, value) in
                switch tag {
                case 100:
                    self?.viewModel?.contact.favorite = value
                case 97:
                    if (MFMessageComposeViewController.canSendText()) {
                        let controller = MFMessageComposeViewController()
                        controller.body = "Message Body"
                        if let phone = self?.viewModel?.contact.phoneNumber{
                            controller.recipients = [phone]
                            controller.messageComposeDelegate = self
                            self?.present(controller, animated: true, completion: nil)
                        }else{
                            self?.view.makeToast("Number not found for this contact")
                        }
                        
                    }else{
                        self?.view.makeToast("Can't send message from this device")
                    }
                case 98:
                    if let url = URL(string: "tel://\(self?.viewModel?.contact.phoneNumber ?? "")"),UIApplication.shared.canOpenURL(url) {
                        if #available(iOS 10, *) {
                            UIApplication.shared.open(url, options: [:], completionHandler:nil)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    } else {
                        self?.view.makeToast("Can't make call from this device")
                    }
                case 99:
                    if MFMailComposeViewController.canSendMail() {
                        let mail = MFMailComposeViewController()
                        mail.mailComposeDelegate = self
                        if let email = self?.viewModel?.contact.emailId{
                            mail.setToRecipients(["\(email)"])
                            mail.setMessageBody("<p>This one is testing for Gojek !</p>", isHTML: true)
                            self?.present(mail, animated: true, completion: nil)
                        }else{
                          self?.view.makeToast("Email not found for this contact")
                        }
                       
                    } else {
                        self?.view.makeToast("Can't send email from this device")
                    }
                default:
                    break
                }
                
            }
             return header
        default:
            return UIView()
        }
     }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section == 0) ? 380 :  0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:

            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "mobile   \(viewModel?.contact.phoneNumber ?? "")"
            case 1:
                cell.textLabel?.text = "email     \(viewModel?.contact.emailId ?? "" )"
            default:
                break
            }
        default:
            break
        }
    }
}

extension ContactDetailViewController: ChangeContactDelegate{
    func changeContactModel(contact: Contact) {
        if let id = self.viewModel?.contact.id{
            self.sourceModel.loadContactDetail(id: id) { (contact) in
                if let response = contact{
                    self.viewModel?.contact = response
                }
                self.contactTableView.reloadData()
            }
        }
}
    
}

extension ContactDetailViewController: MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate{
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result) {
        case .cancelled:
            print("Message was cancelled")
            dismiss(animated: true, completion: nil)
        case .failed:
            print("Message failed")
            dismiss(animated: true, completion: nil)
        case .sent:
            print("Message was sent")
            dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
