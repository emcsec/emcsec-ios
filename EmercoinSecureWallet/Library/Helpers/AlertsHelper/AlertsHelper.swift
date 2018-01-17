//
//  AlertsHelper.swift
//  EmercoinOne
//

import UIKit

class AlertsHelper {
    
    private var operationView:UIView?
    private var progressView:ProgressView?
    
    func showErrorAlert(at error:NSError) {
        let alert = errorAlert(at: error)
        
        if let controller = RootViewController() {
            DispatchQueue.main.async(execute: {
                controller.present(alert, animated: true, completion: nil)
            })
        }
    }
    
    func showErrorViewAlert(at error:NSError) {
        
        let view = loadViewFromXib(name: "Operations", index: 1) as! ErrorView
        view.text = error.domain
        if let controller = RootViewController() {
            view.frame = controller.view.frame
            DispatchQueue.main.async(execute: {
                controller.view.addSubview(view)
                view.layoutIfNeeded()
            })
        }
    }
    
    func showSuccessOperationView(completion:(() -> Void)? = nil) {
        
        let view = loadViewFromXib(name: "Operations", index: 5) as! DoneView
        view.done = {
            completion?()
        }
        if let controller = RootViewController() {
            view.frame = controller.view.frame
            DispatchQueue.main.async(execute: {
                controller.view.addSubview(view)
            })
        }
    }
    
    func showProgressView() {
        
        if progressView != nil {
            return
        }
        
        let view = loadViewFromXib(name: "Operations", index: 2) as! ProgressView
        progressView = view
        if let controller = RootViewController() {
            view.frame = controller.view.frame
            DispatchQueue.main.async(execute: {
                controller.view.addSubview(view)
            })
        }
    }
    
    func updateProgressView(at object:Any) {
        
        if let view = progressView {
            DispatchQueue.main.async(execute: {
                view.updateProgress(at: object)
            })
        }
    }
    
    func hideProgressView() {
        
        if let view = progressView {
            view.removeFromSuperview()
            progressView = nil
        }
    }
    
    func showOperationView() {
        
        if operationView != nil {
            return
        }
        
        let view = loadViewFromXib(name: "Operations", index: 0)
        operationView = view
        if let controller = RootViewController() {
            view.frame = controller.view.frame
            DispatchQueue.main.async(execute: {
                controller.view.addSubview(view)
            })
        }
    }
    
    func hideOperationView() {
        
        if let view = operationView {
            view.removeFromSuperview()
            operationView = nil
        }
        
    }
    
    func errorAlert(at error:NSError) -> BaseAlertController {
        
        let alert = BaseAlertController(
            title: NSLocalizedString("Error", comment: ""),
            message: error.domain,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .cancel, handler: { (action) in
            
        }))
        
        return alert
    }
    
    func baseAlert(at text:String) -> BaseAlertController {
        
        let alert = BaseAlertController(
            title: "",
            message: text,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .cancel, handler: { (action) in
            
        }))
        
        return alert
    }
}
