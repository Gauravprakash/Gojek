//
//  Contact.swift
//  Gojek Demo
//
//  Created by Gaurav Prakash on 07/08/19.
//  Copyright © 2019 Gaurav. All rights reserved.
//

import Foundation

typealias Contacts = [Contact]

struct Contact: Codable {
    let id: Int?
    let firstName, lastName: String?
    let profilePic: String?
    var favorite: Bool?
    let phoneNumber:String?
    let emailId:String?
    let url: String?
    
    
    enum CodingKeys: String, CodingKey {
            case id = "id"
            case firstName = "first_name"
            case lastName = "last_name"
            case profilePic = "profile_pic"
            case favorite = "favorite"
            case phoneNumber = "phone_number"
            case emailId = "email"
            case url = "url"
    }
 
}



