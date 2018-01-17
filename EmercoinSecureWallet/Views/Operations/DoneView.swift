//
//  DoneView.swift
//  EmercoinSecureWallet
//

import UIKit

class DoneView: ErrorView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateUI()
    }
    
    override func updateUI() {
        
        textLabeL.text = NSLocalizedString("Operation was successfully completed", comment: "")
        titleLabeL.text = NSLocalizedString("Done", comment: "")
        doneButton.setTitle(NSLocalizedString("Ok", comment: ""), for: .normal)
    }
}
