//
//  PleaseWaitView.swift
//  EmercoinSecureWallet
//

import UIKit

class PleaseWaitView: PopupView {

    @IBOutlet weak var waitLabeL:UILabel!

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        updateUI()
    }
    
    private func updateUI() {
        
        waitLabeL.text = NSLocalizedString("Please wait", comment: "")
    }
}
