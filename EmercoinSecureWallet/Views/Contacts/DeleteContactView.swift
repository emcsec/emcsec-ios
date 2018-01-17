//
//  DeleteContact.swift
//  EmercoinOne
//

import UIKit

class DeleteContactView: PopupView {

    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var doneButton:YesButton!
    @IBOutlet weak var cancelButton:CancelButton!
    
    var delete:(() -> (Void))?
    
    @IBAction override func doneButtonPressed(sender:UIButton?) {
        if delete != nil {
            delete!()
        }
        super.doneButtonPressed(sender: sender)
    }
    
    var coinType:CoinType = .emercoin {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        
        if coinType == .bitcoin {
            cancelButton.backgroundColor = UIColor(hexString: Constants.Colors.CancelButton.Bitcoin)
            doneButton.backgroundColor = UIColor(hexString: Constants.Colors.Coins.Bitcoin)
        }
        
        doneButton.setTitle(NSLocalizedString("Delete", comment: ""), for: .normal)
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        
        titleLabel?.text = NSLocalizedString("Delete contact", comment: "")
    }
}
