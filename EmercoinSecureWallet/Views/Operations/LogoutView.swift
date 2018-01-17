//
//  LogoutView.swift
//  EmercoinSecureWallet
//

import UIKit

class LogoutView: PopupView {

    @IBOutlet weak var titleLabel:UILabel?
    @IBOutlet weak var textLabel:UILabel?
    @IBOutlet weak var doneButton:YesButton!
    @IBOutlet weak var cancelButton:CancelButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateUI()
    }
    
    private func updateUI() {
        
        titleLabel?.text = NSLocalizedString("Close the wallet", comment: "")
        textLabel?.text = NSLocalizedString("Are you sure want to close the wallet?", comment: "")
        doneButton.setTitle(NSLocalizedString("Yes", comment: ""), for: .normal)
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        
    }
}
