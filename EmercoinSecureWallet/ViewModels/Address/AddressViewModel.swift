//
//  AddressViewModel.swift
//  EmercoinSecureWallet
//

import UIKit

class AddressViewModel: NSObject {

    var name:String
    var address:String
    
    init(address:Address) {
        
        self.name = address.name
        self.address = address.pubAddress
    }
}
