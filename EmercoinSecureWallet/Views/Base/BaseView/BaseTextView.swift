//
//  BaseTextView.swift
//  EmercoinOne
//

import UIKit

class BaseTextView: UITextView, UITextViewDelegate {

    @IBInspectable var downcaseText: Bool = false
    
    var textChanged:((_ text:String) -> (Void))?
    
    override func awakeFromNib() {
        
        delegate = self
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        
        if self.textChanged != nil {
            self.textChanged!((self.text)!)
        }
    }
    
    
}
