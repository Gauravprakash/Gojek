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
    let profilePic: ProfilePic?
    let favorite: Bool?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case profilePic = "profile_pic"
        case favorite, url
    }
}

enum ProfilePic: String, Codable {
    case imagesMissingPNG = "/images/missing.png"
}


