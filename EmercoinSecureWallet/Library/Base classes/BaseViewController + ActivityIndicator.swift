//
//  BaseViewController + ActivityIndicator.swift
//  EmercoinOne
//

import UIKit

extension BaseViewController {
    
    internal func createActivityIndicator() {
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.color = UIColor.darkGray
        indicator.center = view.center
        activiryIndicator = indicator
    }
    
    func showActivityIndicator(at color:UIColor? = nil) {
        
        if activiryIndicator == nil {
            createActivityIndicator()
        }
        
        if let color = color {
            activiryIndicator?.color = color
        }
        
        if Thread.isMainThread {
            startAnimatingActivity()
        } else {
            
            DispatchQueue.main.async {
                self.startAnimatingActivity()
            }
        }
    }
    
    private func startAnimatingActivity() {
        
        activiryIndicator?.startAnimating()
        view.addSubview(activiryIndicator!)
    }
    
    func hideActivityIndicator() {
        
        if Thread.isMainThread {
            stopAnimatingActivity()
        } else {
            
            DispatchQueue.main.async {
                self.stopAnimatingActivity()
            }
        }
    }
    
    private func stopAnimatingActivity() {
        activiryIndicator?.removeFromSuperview()
        activiryIndicator?.stopAnimating()
    }
}
