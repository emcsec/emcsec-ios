//
//  SeedWordValidView.swift
//  EmercoinSecureWallet
//
import UIKit

class SeedWordValidView: UIView {

    @IBOutlet weak var textField:SeedTextField!
    @IBOutlet weak var validView:UIView!
    
    var textChanged:((_ text:String, _ index:Int) -> (Void))?
    var returnKeyPressed:(() -> (Void))?
    
    var isValid = false {
        didSet {
            validView.isHidden = isValid
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField.textChanged = textChanged
        textField.returnKeyPressed = returnKeyPressed
    }

}
