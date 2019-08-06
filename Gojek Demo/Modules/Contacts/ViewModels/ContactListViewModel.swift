//
//  ContactListViewModel.swift
//  Gojek Demo
//
//  Created by Hemant Singh on 05/08/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import Foundation
import Moya
class ContactListViewModel: NSObject{

var apiProvider: MoyaProvider<API> = APIProvider
var onError: ((Error) -> Void)?
var onData: ((Contacts) -> Void)?
    var contactArray:Contacts! = [] {
        didSet {
            onData?(contactArray)
        }
    }


public func fetchContacts() {
    apiProvider.request(API.GETCONTACTS) { [weak self] (result) in
        switch result {
        case .success(let response):
            do {
                // error arising here throwing in catch block .
                let contacts = try JSONDecoder().decode(Contacts.self, from: response.data)
                self?.contactArray = contacts

                } catch {
                self?.onError?(error) }
        case .failure(let error):
            self?.onError?(error)
        }
    }
}
}
