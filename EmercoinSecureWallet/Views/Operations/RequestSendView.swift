//
//  RequestSendView.swift
//  EmercoinOne
//

import UIKit

class RequestSendView: PopupView {
    
    @IBOutlet weak var amountLabel:UILabel?
    @IBOutlet weak var confirmLabel:UILabel?
    @IBOutlet weak var doneButton:YesButton!
    @IBOutlet weak var cancelButton:CancelButton!
    
    var coinType:CoinType = .emercoin {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        
        confirmLabel?.text = NSLocalizedString("Confirm operation", comment: "")
        doneButton.setTitle(NSLocalizedString("Yes", comment: ""), for: .normal)
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        
        if coinType == .bitcoin {
            cancelButton.backgroundColor = UIColor(hexString: Constants.Colors.CancelButton.Bitcoin)
            doneButton.backgroundColor = UIColor(hexString: Constants.Colors.Coins.Bitcoin)
        }
    }
    
}
