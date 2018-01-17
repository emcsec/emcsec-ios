//
//  BaseButton.swift
//  EmercoinOne
//

import UIKit

class BaseButton: UIButton {
    
    @IBInspectable var enableConfig:Bool = false
    
    @IBInspectable var enableColor:String = ""
    @IBInspectable var disableColor:String = ""
    
    override var isEnabled: Bool {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateUI()
    }
    
    private func updateUI() {
        
        if enableConfig {
            let imageName = isEnabled ? enableColor : disableColor
            backgroundColor = UIColor(hexString: imageName)
        }
    }
}
