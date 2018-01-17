//
//  ClipboardView.swift
//  EmercoinSecureWallet
//

import UIKit

class ClipboardView: UIView {

    @IBOutlet private weak var titleLabel:UILabel!
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        updateUI()
    }
    
    private func updateUI() {
        
        titleLabel.text = NSLocalizedString("Saved to clipboard", comment: "")
    }
}
