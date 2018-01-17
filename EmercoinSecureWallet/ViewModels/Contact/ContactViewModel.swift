//
//  ContactViewModel.swift
//  EmercoinOne
//

import UIKit

class ContactViewModel {
    
    var name:String
    var address:String
    
    init(contact:Contact) {
        
        self.name = contact.name
        self.address = contact.address
    }
}
