//
//  ErrorView.swift
//  EmercoinSecureWallet
//


import UIKit

class ErrorView: PopupView {

    @IBOutlet internal weak var doneButton:UIButton!
    @IBOutlet internal weak var titleLabeL:UILabel!
    @IBOutlet internal weak var textLabeL:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.black.withAlphaComponent(0.25)
    }
    
    var text:String = "" {
        didSet {
            updateUI()
        }
    }
    
    internal func updateUI() {
        
        textLabeL.text = text
        titleLabeL.text = NSLocalizedString("Error", comment: "")
        doneButton.setTitle(NSLocalizedString("Ok", comment: ""), for: .normal)
    }
}
