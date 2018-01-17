//
//  ExpireDaysTextField.swift
//  EmercoinBasic
//

import UIKit

class ExpireDaysTextField: BaseTextField {

    var isEditMode = false
    
    public override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if disableEdit {
            return false
        }
        
        let text = textField.text!
        let fullText = text.insert(string, index: range.location)
        let length = fullText.length
        let first = fullText.first
        
        
        if !isEditMode {
            if length == 1 {
                return !(first == "0")
            }
        } else if length > 1 && first == "0" {
            return false
        }
        return maxCharacters == 0 ? true : fullText.length <= maxCharacters
    }
}
