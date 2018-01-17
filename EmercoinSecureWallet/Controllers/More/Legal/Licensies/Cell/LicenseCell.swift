//
//  LicenseCell.swift
//  EmercoinBasic
//

import UIKit

class LicenseCell: BaseTableViewCell {

    @IBOutlet internal weak var nameLabel:UILabel!
    
    override func updateUI() {
        
        guard let viewModel = object as? LicenseViewModel else {
            return
        }
        
        nameLabel.text = viewModel.name + " License"
    }
}
