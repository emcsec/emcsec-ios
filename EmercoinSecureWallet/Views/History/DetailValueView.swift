//
//  DetailValueView.swift
//  EmercoinOne
//

import UIKit

class DetailValueView: NVSValueView {

    @IBOutlet internal weak var valueScrollView:UIScrollView!
    @IBOutlet internal weak var valueLabel:UILabel!
    @IBOutlet internal weak var valueButton:UIButton!
    @IBOutlet internal weak var nameLabel:UILabel!
    
    @IBInspectable var enableCopy:Bool = false
    
    var copyPressed:(() -> (Void))?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        valueButton.addTarget(self, action:#selector(self.copyHandler), for: UIControlEvents.touchUpInside)
    }
    
    var name:String = "" {
        didSet {
            nameLabel?.text = String(format:"%@:",name)
        }
    }
    
    var value:String? {
        didSet {
            updateValue()
        }
    }
    
    private func updateValue() {
        
        if let value = value {
            valueLabel.text = value
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.valueScrollView.flashScrollIndicators()
            }
        }
    }
    
    @objc func copyHandler() {
        if enableCopy && copyPressed != nil {
            copyPressed!()
        }
    }
}
