//
//  Router.swift
//  EmercoinOne
//

import Foundation
import UIKit

class Router {
    
    internal static let sharedInstance = Router()
    
    internal var tabBar:TabBarController?
    
    private func changeRootController(to viewController: UIViewController) {
    
        DispatchQueue.main.async {
            if let window = UIApplication.shared.delegate?.window {
                UIView.transition(with: window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    window?.rootViewController = viewController
                }, completion: nil)
            }
        }
    }
    
    internal func showInitialController() {
        let login = controller(at: "initial")
        changeRootController(to:login)
    }
    
    internal func showMainController() {
        let main = controller(at: "main")
        changeRootController(to:main)
        
    }
    
    func initialController() -> UIViewController {
        
        var name = "initial"
        
        let addresses = Addresses()
        
        if addresses.addresses.count != 0 {
            name = "main"
        }
        
        return controller(at: name)
    }
    
    private func controller(at name:String) -> UIViewController {
        
        var controller = UIViewController()
        
        switch name {
        case "main":let vc = mainController() as! TabBarController
                    self.tabBar = vc
                    return vc
        case "initial":controller = InitialViewController.controller()
        default:
            break
        }
        
        let nav = BaseNavigationController(rootViewController: controller)
        return nav
    }
    
    private func mainController() -> UIViewController {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "TabBarController")
        return vc
    }
}
