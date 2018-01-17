//
//  BaseViewController.swift
//  EmercoinOne
//

import UIKit

protocol ViewControllerInit {
    
}

class BaseViewController: UIViewController, UIGestureRecognizerDelegate, TabBarObjectInfo {
    
    internal var activiryIndicator:UIActivityIndicatorView?
    
    var tabBarObject: TabBarObject?
    internal weak var statusBarView:UIView?
    
    func dissmisModal() {
        dismiss(animated: true, completion: nil)
    }
    
    class func controller() -> UIViewController {
        
        let storyboardName = self.storyboardName()
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let controllerIdentifier = String(describing: self)
        let controller = storyboard.instantiateViewController(withIdentifier: controllerIdentifier)
        return controller
    }
    
    class func storyboardName() -> String {
        // override method for other storyboard names
        return "Main"
    }
    
    var isLoading = false
    
    var object:AnyObject?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    deinit {
        
        if Constants.Permissions.PrintDeinit {
            print("deinit - "+String(describing: self))
        }
    }
    
    func setupUI() {
        
        addStatusBarView()
    }
    
    func hideStatusBar() {
        statusBarView?.isHidden = true
    }
    
    func addStatusBarView(color:UIColor? = nil) {
        
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 20.0))
        let color = color ?? UIColor(hexString: Constants.Colors.Status.Base)
        view.backgroundColor = color
        
        if statusBarView != nil {
            statusBarView?.backgroundColor = color
            statusBarView?.isHidden = false
        } else {
            statusBarView = view
            self.view.addSubview(view)
        }
    }
    
    func hideNavBar(state:Bool) {
        navigationController?.navigationBar.isHidden = state
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @IBAction func back() {
        
        self.navigationController?.popViewController(animated: true)
    }
}
