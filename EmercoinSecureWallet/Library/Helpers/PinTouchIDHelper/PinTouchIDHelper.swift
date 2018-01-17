//
//  PinTouchIDHelper.swift
//  EmercoinSecureWallet
//

import UIKit
import LocalAuthentication

enum ProtectionType:Int {
    case pin
    case setPin
    case touchID
}

class PinTouchIDHelper: NSObject {
    
    var fromController:UIViewController?
    var isParentController = false
    var isNeedSetPin = false
    var isNeedRequestSetTouchID = false
    var done:(() -> (Void))?
    var enterPin:(() -> (Void))?
    var cancel:(() -> (Void))?
    
    private var pinTouchID:PinTouchID = PinTouchID()
    private var pinView:UIView?
    
    func startProtection() {
        
        if let pinTouchID = Settings.pinTouchID {
            if pinTouchID.pin.isEmpty{
                if isNeedSetPin {
                    self.showPinView(at: .set)
                } else {
                    doneOperation()
                }
            } else if pinTouchID.isEnabledPin {
                showTouchIDView(at: pinTouchID.isEnabledTouchID)
            } else {
                doneOperation()
            }
        } else {
            isNeedRequestSetTouchID = true
            showRequestView(at: .pin)
            
        }
    }
    
    private func saveState() {
        Settings.addPinTouchID(at: self.pinTouchID)
        self.doneOperation()
    }
    
    private func showRequestView(at type:ProtectionType) {
        
        let view = getView(at: .pin) as! PinTouchIDRequestView
        view.type = type
        
        view.enable = {
            if type == .pin {
                self.showPinView(at: .set)
            } else {
                self.pinTouchID.isEnabledTouchID = true
                self.saveState()
            }
        } as (() -> (Void))
        view.cancel = {
            self.saveState()
        }
        showView(at: view)
    }
    
    func showPinView(at type:EnterPinType) {
        
        let view = getView(at: .setPin) as! EnterPinView
        
        if type == .confirm {
            view.enteredPin = self.pinTouchID.pin
        }
        
        view.type = type
        
        view.set = {pin in
            
            self.pinTouchID.pin = pin
            self.pinTouchID.isEnabledPin = true
            self.showPinView(at: .confirm)
        }
        view.confirm = {state in
            if state {
                if self.isNeedRequestSetTouchID {
                    self.showRequestView(at: .touchID)
                } else {
                    self.saveState()
                }
            }
        }
        view.enable = {pin in
            
            if self.enterPin != nil {
                self.enterPin!()
            }
            
            self.doneOperation()
        }
        view.cancel = {
            if self.cancel != nil {
                
                if type == .confirm {
                    self.pinTouchID.pin = ""
                    self.pinTouchID.isEnabledPin = false
                    self.saveState()
                } else if type == .set {
                    self.saveState()
                }
                self.cancel!()
            }
        }
        showView(at: view)
        self.pinView = view
    }
    
    private func doneOperation() {
        
        DispatchQueue.main.async {
            
            if let view = self.pinView {
                view.removeFromSuperview()
            }
            
            if self.done != nil {
                self.done!()
            }
        }
    }
    
    private func showTouchIDView(at touchID:Bool) {

        let context = LAContext()
        var error: NSError?
        
        let reasonString = "Authentication is needed to access your wallet"
        
        self.showPinView(at: .unlock)
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) && touchID {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString) { (success, error) in
                
                if success {
                    print("success")
                    self.doneOperation()
                } else {
                    if let error = error as NSError? {
                        DispatchQueue.main.async {
                          print(error.localizedDescription)
                        }
                        
                    }
                }
            }
        }
    }
    
    private func getView(at type:ProtectionType) -> UIView {
        
        let view = loadViewFromXib(name: "PinTouchID", index: type.rawValue)
        return view
    }
    
    private func showView(at view:UIView) {
        
        if let controller = self.fromController {
            
            if isParentController {
                if let parent = controller.parent {
                    showView(at: parent, view: view)
                }
            } else {
                showView(at: controller, view: view)
            }
        }
    }
    
    private func showView(at controller:UIViewController, view:UIView) {
        view.frame = controller.view.frame
        controller.view.addSubview(view)
    }
}
