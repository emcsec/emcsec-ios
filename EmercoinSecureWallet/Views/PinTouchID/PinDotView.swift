//
//  PinDotView.swift
//  EmercoinSecureWallet
//

import UIKit

class PinDotView: UIImageView {

    var isSelected = false {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        
        let imageString = isSelected ? "pin_dot" : "pin_dot_empty"
        
        if let image = UIImage.init(named: imageString) {
            self.image = image
        }
    }
}
