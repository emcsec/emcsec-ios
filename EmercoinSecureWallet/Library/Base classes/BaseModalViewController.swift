//
//  BaseModalViewController.swift
//  EmercoinSecureWallet
//

import UIKit

class BaseModalViewController: UIViewController {

    var modalView:UIView?
    var close:(() -> (Void))?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = modalView as? PopupView {
            
            view.cancel = {[weak self] in
                self?.closeController()
            }
            view.done = {[weak self] in
                self?.closeController()
            }
            
            view.frame = self.view.frame
            self.view.addSubview(view)
        }
    }
    
    private func closeController() {
        
        if close != nil {
            close!()
        }
        dismiss(animated: true, completion: nil)
    }
    
    deinit {
        if Constants.Permissions.PrintDeinit {
            print("deinit - "+String(describing: self))
        }
    }
}
