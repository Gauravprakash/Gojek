//
//  ContactDetailViewModel.swift
//  Gojek Demo
//
//  Created by Hemant Singh on 06/08/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import Foundation

class ContactDetailViewModel : NSObject{
    public let contact: Contact
    
    init(model contact: Contact) {
        self.contact = contact
    }
    
}
