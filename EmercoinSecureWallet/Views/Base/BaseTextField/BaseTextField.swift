//
//  BaseTextField.swift
//  EmercoinOne
//

import UIKit
import RxSwift
import RxCocoa

class BaseTextField: UITextField, UITextFieldDelegate {
    
    @IBInspectable var maxCharacters: Int = 0
    @IBInspectable var maxIntCharacters: Int = 0
    @IBInspectable var disableEdit: Bool = false
    @IBInspectable var validAmount: Bool = false
    @IBInspectable var enableBorder: Bool = false
    @IBInspectable var isOnlyDigits: Bool = false
    
    var done:((_ text:String) -> (Void))?
    var textChanged:((_ text:String) -> (Void))?
    var didFirstResponder:((_ state:Bool) -> (Void))?
    
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        delegate = self
        
        self.rx.controlEvent([.editingChanged])
            .asObservable()
            .subscribe(onNext: {(_) in
                if self.textChanged != nil {
                    self.textChanged!((self.text)!)
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    
        updateUI()
    }
    
    private func updateUI() {
        
        if isEnabled == false {
            self.backgroundColor = UIColor(white: 1, alpha: 0.0)
        }
        
        if enableBorder {
            let color = UIColor(hexString: "CCCCCC")//UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0) - default
            let borderWidth = 1.0
            let cornerRadius = 10.0
            fullyRound(diameter: CGFloat(cornerRadius), borderColor: color, borderWidth: CGFloat(borderWidth))
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        
        if didFirstResponder != nil {
            didFirstResponder!(true)
        }
        
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        if done != nil {
            done!(self.text!)
        }
        if didFirstResponder != nil {
            didFirstResponder!(false)
        }
        return super.resignFirstResponder()
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if disableEdit {
            return false
        }
        
        if isOnlyDigits {
            
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            
            if !(string == numberFiltered) {
                return false
            }
        }
        
        let text = textField.text!
        
        var fullText = text.insert(string, index: range.location)
        fullText = fullText.replacingOccurrences(of: ",", with: ".")
        
        if validAmount {
            if fullText.contains(".") {
                return fullText.validAmount()
            } else {
                return maxIntCharacters == 0 ? true : fullText.length <= maxIntCharacters
            }
        } else {
            return maxCharacters == 0 ? true : fullText.length <= maxCharacters
        }
    }
}
