//
//  ContactDetailViewModel.swift
//  Gojek Demo
//
//  Created by Gaurav Prakash on 07/08/19.
//  Copyright © 2019 Gaurav. All rights reserved.
//

import Foundation
import Moya

protocol ChangeContactDelegate : class {
    func changeContactModel(contact:Contact)
}

class ContactDetailViewModel : NSObject{
    public var contact: Contact
    var apiProvider: MoyaProvider<API> = APIProvider
    var onError: ((Error) -> Void)?
    
      init(model contact: Contact) {
        self.contact = contact
    }
}

struct ContactData {
    var firstname:String?
    var lastname:String?
    var mobile:String?
    var email:String?
    var isFavourite:Bool? = false
    
    init(){}
    
    init(contact:Contact){
        self.firstname = contact.firstName
        self.lastname = contact.lastName
        self.mobile = contact.phoneNumber
        self.email = contact.emailId
        self.isFavourite = contact.favorite
       }
    func validateData() -> (Bool, String){
        if firstname == nil  {
            return(false, "please enter first name")
        }
        else if lastname == nil {
            return(false, "please enter last name")
        }
        else if mobile == nil{
            return(false, "please enter mobile number")
        }
        else if email == nil{
            return(false, "please enter your email Id")
        }
        else{
            return (true, "")
        }
    }
    
    func toDictionary() -> [String:Any]{
        var dictionary = [String:Any]()
        if firstname != nil{
            dictionary["first_name"] = firstname
        }
        if lastname != nil{
            dictionary["last_name"] = lastname
        }
        if mobile != nil{
            dictionary["phone_number"] = mobile
        }
        if email != nil{
            dictionary["email"] = email
        }
        dictionary["favorite"] = isFavourite
        
        return dictionary
    }
    
    
}

