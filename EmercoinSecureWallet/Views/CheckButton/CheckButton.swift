//
//  CheckButton.swift
//  EmercoinSecureWallet
//

import UIKit

class CheckButton: UIButton {
    
    var isCheked:Bool = false {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        
        let checkImageString = isCheked ? "r_but_on_image" : "r_but_off_image"
        let image = UIImage(named: checkImageString)
        setImage(image, for: .normal)
    }
}
