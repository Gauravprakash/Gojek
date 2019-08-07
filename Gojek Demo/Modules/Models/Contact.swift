//
//  Contact.swift
//  Gojek Demo
//
//  Created by Hemant Singh on 05/08/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import Foundation

typealias Contacts = [Contact]

struct Contact: Codable {
    let id: Int?
    let firstName, lastName: String?
    let profilePic: String?
    let favorite: Bool?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
            case id = "id"
            case firstName = "first_name"
            case lastName = "last_name"
            case profilePic = "profile_pic"
            case favorite = "favorite"
            case url = "url"
    }
 
    init(id: Int, firstName: String, lastName: String, profilePic: String, favorite: Bool, url: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.profilePic = profilePic
        self.favorite = favorite
        self.url = url
    }
}



