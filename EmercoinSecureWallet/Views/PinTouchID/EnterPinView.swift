 //
//  EnterPinView.swift
//  EmercoinSecureWallet
//

import UIKit

enum EnterPinType {
    case unlock
    case enable
    case set
    case confirm
    
    var title:String {
        var string = ""
        switch self {
            case .set:
                string = NSLocalizedString("Set a PIN", comment: "")
            case .confirm:
                string = NSLocalizedString("Confirm a PIN", comment: "")
            case .enable,.unlock:
                string = NSLocalizedString("Enter a PIN", comment: "")
        }
        return string
       
    }
}

class EnterPinView: PopupView {
    
    @IBOutlet weak var doneButton:YesButton!
    @IBOutlet weak var okButton:BaseButton!
    @IBOutlet weak var cancelButton:CancelButton!
    @IBOutlet weak var buttonView:UIView!
    @IBOutlet weak var buttonsView:UIView!
    @IBOutlet weak var pinView:UIView!
    @IBOutlet weak var title:UILabel!
    @IBOutlet var pinDotViews: [PinDotView]!
    
    var set:((_ pin:String) -> (Void))?
    var confirm:((_ state:Bool) -> (Void))?
    var enable:((_ pin:String) -> (Void))?
    
    var type:EnterPinType = .unlock {
        didSet {
            updateUI()
        }
    }
    
    private var pin = ""
    var enteredPin = ""
    
    private func updateUI() {
        title.text = type.title
        
        var doneTitle = ""
        
        switch type {
            case .set, .confirm:
                buttonView.isHidden = true
                doneTitle = type == .set ? NSLocalizedString("Set", comment: "") : NSLocalizedString("Confirm", comment: "")
            case .unlock:
                buttonsView.isHidden = true
            case .enable:
                buttonView.isHidden = true
                doneTitle = NSLocalizedString("Ok", comment: "")
        }
        
        doneButton.setTitle(doneTitle, for: .normal)
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
    }
    
    private func validatePin() {
        
        switch type {
        case .set:
            doneButton.isEnabled = pin.length == Constants.PinLength
        case .confirm:
            doneButton.isEnabled = pin == enteredPin
            if (pin.length == Constants.PinLength) && (pin != enteredPin) {
                clearPinView()
            }
        case .enable, .unlock:
            if let pin = Settings.pinTouchID {
                
                let isValid = self.pin == pin.pin
                
                if (self.pin.length == Constants.PinLength) && !isValid {
                    clearPinView()
                }
                
                if type == .enable {
                    doneButton.isEnabled = isValid
                } else {
                    okButton.isEnabled = isValid
                }
            }
        }
    }
    
    private func clearPinView() {
        
        pin = ""
        
        pinDotViews.forEach { (pinView) in
            pinView.isSelected = false
        }
        animateNoValidPinView(repeatAnimation: true)
    }
    
    private func animateNoValidPinView(repeatAnimation:Bool = false) {
        
        UIView.animate(withDuration: 0.1, animations: {
            self.pinView.frame.origin.x -= 20
        }) { (state) in
            self.pinView.frame.origin.x += 20
            if repeatAnimation {
                self.animateNoValidPinView()
            }
        }
    }
    
    @IBAction func numberButtonPressed(sender:UIButton) {
        
        if pin.length != Constants.PinLength {
            pin = pin + "\(sender.tag)"
            pinDotViews.filter{$0.tag == pin.length}.forEach({ (pinView) in
                pinView.isSelected = true
            })
            validatePin()
        }
    }
    
    @IBAction override func doneButtonPressed(sender:UIButton?) {
        
        if type == .set {
            if set != nil {
                set!(pin)
            }
        } else if type == .confirm {
            if confirm != nil {
                confirm!(true)
            }
        } else {
            if enable != nil {
                enable!(pin)
            }
        }
        
        super.doneButtonPressed(sender: sender)
    }
    
    @IBAction override func cancelButtonPressed(sender: UIButton?) {
        if type == .confirm {
            if confirm != nil {
                confirm!(false)
            }
        }
        
        super.cancelButtonPressed(sender: sender)
    }
    
    @IBAction func clear() {
        
        pin = ""
        pinDotViews.forEach({ (pinView) in
            pinView.isSelected = false
        })
        
        validatePin()
    }
}
