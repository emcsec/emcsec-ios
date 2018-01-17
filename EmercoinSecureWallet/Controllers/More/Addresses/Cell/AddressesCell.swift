//
//  AddressesCell.swift
//  EmercoinSecureWallet
//

import UIKit

class AddressesCell: BaseSwipeTableViewCell {

    @IBOutlet weak var nameLabeL:UILabel!
    @IBOutlet weak var addressLabeL:UILabel!
    
    override func updateUI() {
        
        guard let viewModel = object as? AddressViewModel else {
            return
        }
        
        nameLabeL.text = viewModel.name
        addressLabeL.text = viewModel.address
    }
}
