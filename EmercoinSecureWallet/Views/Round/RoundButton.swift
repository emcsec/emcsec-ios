//
//  RoundButton.swift
//  EmercoinBasic
//

import UIKit

class RoundButton: BaseButton {
    
    @IBInspectable var diameter:CGFloat = 0.0
    @IBInspectable var borderColor:String = ""
    @IBInspectable var borderWidth:CGFloat = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let color:UIColor? = UIColor(hexString: borderColor)
        
        let diameter = self.diameter == 0.0 ? frame.size.height : self.diameter
        
        fullyRound(diameter: diameter, borderColor: color ?? .clear, borderWidth: borderWidth)
    }
    
    override var isHighlighted: Bool {
        didSet {
            
        }
    }
}
