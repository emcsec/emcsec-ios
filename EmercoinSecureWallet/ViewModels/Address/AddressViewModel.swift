//
//  AddressViewModel.swift
//  EmercoinSecureWallet
//

import UIKit

class AddressViewModel: NSObject {

    var name:String
    var address:String
    var key:String
    var isChange:Bool
    var nameColor:UIColor = .black
    
    init(address:Address) {
        
        self.name = address.name
        self.address = address.pubAddress
        self.key = address.privKey
        self.isChange = address.isUsingForChange
        if isChange {
            self.name = NSLocalizedString("Address for change", comment: "")
            self.nameColor = .lightGray
        }
    }
}
