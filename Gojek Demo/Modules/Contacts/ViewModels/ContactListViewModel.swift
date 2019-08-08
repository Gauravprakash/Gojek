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
var contactDictionary = [String: [Contact]]()
var keys = [String]()
var alphabets = (97...122).map { "\(Character(UnicodeScalar.init($0)!))" }.map { $0.uppercased() }
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
                self?.setContacts(contact: contacts)
                self?.contactArray = contacts
                } catch {
                self?.onError?(error) }
        
        case .failure(let error):
            self?.onError?(error)
        }
    }
}
    
    public func loadContactDetail(id:Int, completionHandler: @escaping (Contact?) -> Void){
        apiProvider.request(API.CONTACTDETAILS(id)) { [weak self] (result) in
            switch result {
            case .success(let response):
                do {
                    let contact = try JSONDecoder().decode(Contact.self, from: response.data)
                    completionHandler(contact)
                } catch {
                    self?.onError?(error) }
                
            case .failure(let error):
                self?.onError?(error)
            }
        }
    }
    
    public func deleteContact(id:Int, completionHandler: @escaping (Bool?) -> Void){
        apiProvider.request(API.DELETECONTACT(id)) { [weak self] (result) in
            switch result {
            case .success:
                    completionHandler(true)

            case .failure(let error):
                self?.onError?(error)
            }
        }
    }
    

    private func setContacts(contact:Contacts) {
    var temp = [String: [Contact]]() //A temporary array
    for contact in contact {
    if let firstName = contact.firstName, !firstName.isEmpty { //In my case, the firstName is an optional string
    let firstChar = "\(firstName.first!)".uppercased()
    if alphabets.contains(firstChar) {
    var array = temp[firstChar] ?? []
    array.append(contact)
    temp[firstChar] = array
    } else {
    var array = temp["#"] ?? []
    array.append(contact)
    temp["#"] = array
    }
    }
    }
    self.keys = Array(temp.keys).sorted() 
    for key in self.keys { self.contactDictionary[key] = temp[key] }
    }
}





