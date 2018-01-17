//
//  SeedTextField.swift
//  EmercoinSecureWallet
//

import UIKit

class SeedTextField: UITextField, UITextFieldDelegate {
    
    var textChanged:((_ text:String, _ index:Int) -> (Void))?
    var returnKeyPressed:(() -> (Void))?
    
    private var validView:UIView?
    
    var index:Int = 0
    
    var isValid = false {
        didSet {
            showValidView(state:isValid)
        }
    }
    
    private func showValidView(state:Bool) {
        
        if let validView = validView {
            validView.isHidden = state
        } else {
            let view = UIView()
            view.frame.size.width = frame.size.width - 4
            view.frame.size.height = 0.5
            view.backgroundColor = UIColor.red
            view.frame.origin.x = 2
            view.frame.origin.y = 30
            view.isHidden = state
            validView = view
            addSubview(view)
        }
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        delegate = self
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let char = string.cString(using: String.Encoding.utf8)!
        let backSpace = strcmp(char, "\\b")
        
        let isBackSpace = backSpace == -92
        
        let currentText = textField.text ?? ""
        
        var text = currentText + string.lowercased().replacingOccurrences(of: " ", with: "")
        
        if isBackSpace {
            text = text.removeLast()
        }
        
        if text.validSeedWord() {
            textField.text = text
            self.textСhange()
        }
        
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if self.returnKeyPressed != nil {
            self.returnKeyPressed!()
        }
        return true
    }
    
    private func textСhange() {
        
        if self.textChanged != nil {
            self.textChanged!((self.text)!,self.tag)
        }
    }
}
