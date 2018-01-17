//
//  SpendingPasswordChange.swift
//  EmercoinOne
//

import UIKit

class PinTouchIDRequestView: PopupView {
    
    @IBOutlet weak var textLabel:UILabel!
    @IBOutlet weak var doneButton:YesButton!
    @IBOutlet weak var cancelButton:CancelButton!
    
    var enable:(() -> (Void))?
    
    var type:ProtectionType = .pin {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        
        let text = type == .touchID ? NSLocalizedString("Would you like to set up a Touch ID?", comment: "") : NSLocalizedString("Would you like to set up a PIN?", comment:"")
        
        textLabel?.text = text
        
        doneButton.setTitle(NSLocalizedString("Yes", comment: ""), for: .normal)
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
    }
    
    @IBAction override func doneButtonPressed(sender:UIButton?) {
        
        if enable != nil {
            enable!()
        }
        
        super.doneButtonPressed(sender: sender)
    }
}
