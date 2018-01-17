//
//  BaseModalViewController.swift
//  EmercoinSecureWallet
//

import UIKit

class BaseModalViewController: UIViewController {

    var modalView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = modalView as? PopupView {
            
            view.cancel = {[weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
            view.done = {[weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
            
            view.frame = self.view.frame
            self.view.addSubview(view)
        }
    }
    
    deinit {
        if Constants.Permissions.PrintDeinit {
            print("deinit - "+String(describing: self))
        }
    }
}
