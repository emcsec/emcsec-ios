//
//  TabBarController.swift
//  EmercoinSecureWallet
//

import UIKit

class TabBarController: UITabBarController {
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        addControllers()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        //addControllers()
    }
    
    var isShowingPinView = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func showSendController(at data:AnyObject) {
        showController(at: data, index: 1)
    }
    
    func showGetCoinsController(at data:AnyObject) {
        showController(at: data, index: 2)
    }
    
    func showAddressesController(at data:AnyObject) {
        showController(at: data, index: 4)
    }
    
    func showController(at data:AnyObject, type:CoinsOperation) {
        
        let index = type.rawValue
        
        checkChildControllers(at: index)
        
        guard let nav = viewControllers?[index] as? BaseNavigationController else {
            return
        }
        
        switch type {
        case .addresses:
            guard let controller = nav.viewControllers.first as? MoreViewController else {
                return
            }
            controller.showAddressesController(at: data)
        case .recipientAddress,.history,.receive:
            guard let controller = nav.viewControllers.first as? CoinsContainerViewController else {
                return
            }
            controller.object = data
        default:
            break
        }

        
        selectedIndex = index
        
    }
    
    func showHistoryController(at data:AnyObject) {
        showController(at: data, index: 3)
    }
    
    private func checkChildControllers(at index:Int) {
        
        guard let nav = viewControllers?[index] as? BaseNavigationController else {
            return
        }
        
        if nav.viewControllers.count > 1 {
            nav.popToRootViewController(animated: false)
        }
    }
    
    func showController(at data:AnyObject, index:Int) {
        
        checkChildControllers(at: index)
        
        guard let nav = viewControllers?[index] as? BaseNavigationController else {
            return
        }
        
//        guard let controller = nav.viewControllers.first as? CoinsOperationViewController else {
//            return
//        }
        
        if index == 4 {
            guard let controller = nav.viewControllers.first as? MoreViewController else {
                            return
            }
            controller.showAddressesController(at: data)
        } else {
//            guard let controller = nav.viewControllers.first as? CoinsOperationViewController else {
//                return
//            }
            //controller.showController(at: data)
        }
        
        selectedIndex = index
    }
    
    internal override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print(item.description)
        
        guard let index = tabBar.items?.index(of: item) else {
            return
        }
        
        checkChildControllers(at: index)
    }
    
    func showPinView() {
        
        if !isShowingPinView {
            showTabBar(at: false)
            
            if let controller = RootViewController() {
                let pinTouchIDHelper = PinTouchIDHelper()
                pinTouchIDHelper.fromController = controller
                pinTouchIDHelper.done = {
                    showTabBar(at: true)
                    self.isShowingPinView = false
                    AppManager.sharedInstance.isNeedShowPinProtection = false
                }
                pinTouchIDHelper.cancel = {
                    showTabBar(at: true)
                    self.isShowingPinView = false
                }
                isShowingPinView = true
                pinTouchIDHelper.startProtection()
            }
        }
    }
    
    private func setupUI() {
        
        tabBar.tintColor = UIColor(hexString: Constants.Colors.TabBar.Tint)
        
        let appearance = UITabBarItem.appearance()
        appearance.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -4)
    }
    
    private func addControllers() {
        
        let dash = DashboardViewController.controller() as! DashboardViewController
        let dashNav = BaseNavigationController(rootViewController: dash)
        let send = loadController(at: "CoinsContainerViewController", storyboard: "CoinsOperation") as! CoinsContainerViewController
        let sendNav = BaseNavigationController(rootViewController: send)
        let receive = loadController(at: "CoinsContainerViewController", storyboard: "CoinsOperation") as! CoinsContainerViewController
        let receiveNav = BaseNavigationController(rootViewController: receive)
        let history = loadController(at: "CoinsContainerViewController", storyboard: "CoinsOperation") as! CoinsContainerViewController
        let historyNav = BaseNavigationController(rootViewController: history)
        let more = MoreViewController.controller() as! MoreViewController
        let moreNav = BaseNavigationController(rootViewController: more)
        
        
        send.coinsOperation = .recipientAddress
        send.tabBarObject = TabBarObject(title: Constants.TabTitle.Send,
                                         imageName: Constants.TabImage.Send)
        
        receive.coinsOperation = .receive
        receive.tabBarObject = TabBarObject(title: Constants.TabTitle.Receive,
                                        imageName: Constants.TabImage.Receive)
        
        history.coinsOperation = .history
        history.tabBarObject = TabBarObject(title: Constants.TabTitle.History,
                                            imageName: Constants.TabImage.History)
        
//        sendNew.tabBarObject = TabBarObject(title: Constants.TabTitle.Names,
//                                            imageName: Constants.TabImage.Names)
        
        more.tabBarObject = TabBarObject(title: Constants.TabTitle.More,
                                          imageName: Constants.TabImage.More)
        
        viewControllers = [dashNav,sendNav,receiveNav,historyNav,moreNav]
        
        let count:Int = (viewControllers?.count)!
        
        for index in 0...count - 1 {
            
            let tabHome = tabBar.items?[index]
            
            let navVC = viewControllers?[index] as! UINavigationController
            guard let vc = navVC.viewControllers.first as? TabBarObjectInfo else {
                break
            }
            
            if let item = vc.tabBarObject {
                tabHome?.title = item.title
                tabHome?.image = UIImage(named:item.imageName)
            }
        }
    }
}
