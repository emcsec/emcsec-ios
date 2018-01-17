//
//  CoinsViewController.swift
//  EmercoinSecureWallet
//

import UIKit

enum CoinsOperation:Int {
    case recipientAddress = 1
    case send = 5
    case addresses = 4
    case receive = 2
    case operations  = 6
    case history = 3
    
    var title:String {
        var string = ""
        switch self {
        case .receive:
            string = Constants.CoinsOperation.Receive
        case .recipientAddress:
            string = Constants.CoinsOperation.RecipientAddress
        case .addresses:
            string = Constants.CoinsOperation.Addresses
        case .send:
            string = Constants.CoinsOperation.Send
        case .history:
            string = Constants.CoinsOperation.History
        case .operations:
            string = Constants.CoinsOperation.Operations
        }
        return string
    }
}

enum Side:Int{
    case left
    case right
}

class CoinsContainerViewController: ButtonBarPagerTabStripViewController, TabBarObjectInfo {

    let emerColor:UIColor = UIColor(hexString: Constants.Colors.Coins.Emercoin)
    let bitColor:UIColor = UIColor(hexString: Constants.Colors.Coins.Bitcoin)
    let emerStausColor:UIColor = UIColor(hexString: Constants.Colors.Status.Emercoin)
    let bitStatusColor:UIColor = UIColor(hexString: Constants.Colors.Status.Bitcoin)
    let backgroundColor = UIColor(hexString: "#EAEAEA")

    var tabBarObject: TabBarObject?
    
    @IBOutlet weak var headerView:MainHeaderView!
    @IBOutlet internal weak var backButton:UIButton!
    @IBOutlet internal weak var viewWidthConstraint:NSLayoutConstraint!
    @IBOutlet internal weak var viewHeightConstraint:NSLayoutConstraint!
    @IBOutlet internal weak var barViewHeightConstraint:NSLayoutConstraint!
    
    @IBOutlet internal weak var scrollView:UIScrollView!
    
    private var firstViewController:UIViewController?
    private var secondViewController:UIViewController?
    
    private var isManaulSelect = false
    
    var object:AnyObject?
    
    var coinsOperation:CoinsOperation = .send
    var coinType:CoinType = .emercoin
    
    var statusView:UIView?

    override func viewDidLoad() {
        
        setupUI()
        
        super.viewDidLoad()
        
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateController()
        
    }
    
    internal func updateController() {
    
        if let data = object as? [String : Any] {
            guard let coin = data["coin"] as? CoinType else {
                return
            }
            
            if coinsOperation == .recipientAddress {
                if let vc = (coin == .bitcoin ? secondViewController : firstViewController) as? RecipientViewController {
                    vc.object = object
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        vc.updateController()
                    })
                }
            } else if coinsOperation == .receive {
                if let vc = (coin == .bitcoin ? secondViewController : firstViewController) as? ReceiveViewController  {
                    vc.object = object
                    vc.updateController()
                }
            }
            
            if coinsOperation != .send {
                showCoinTab(at: coin)
            }
            
//            if coinsOperation == .recipientAddress {
//                if let vc = (coin == .bitcoin ? secondViewController : firstViewController) as? RecipientViewController {
//                    vc.object = object
//                    vc.updateController()
//                }
//            } else if coinsOperation == .receive {
//                if let vc = (coin == .bitcoin ? secondViewController : firstViewController) as? ReceiveViewController  {
//                    vc.object = object
//                    vc.updateController()
//                }
//            }
            
            object = nil
        }
    }
    
    func showCoinTab(at type:CoinType) {
        
        let index = type == .bitcoin ? 1 : 0
        
        if currentIndex != index {
            isManaulSelect = true
            moveToViewController(at: index, animated: true)
            buttonBarView.reloadData()
        }
    }
    
    private func updateUI() {
        
        viewWidthConstraint.constant = screenSize().size.width
        
        if #available(iOS 11, *) {
        } else {
            scrollView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0)
            scrollView.isScrollEnabled = false
        }
        let defaultValue:CGFloat = 70.0
        
        let isSendOrOperationsController = (coinsOperation == .send ) || (coinsOperation == .operations)
        
        let optinalSendValue:CGFloat = (isSendOrOperationsController ) ? buttonBarView.frame.height : 0.0
        
        let height = screenSize().size.height - (headerView.frame.size.height + buttonBarView.frame.size.height + defaultValue - optinalSendValue)
        viewHeightConstraint.constant = height
        
        var title = coinsOperation.title.uppercased()
        
        if coinsOperation == .send || coinsOperation == .operations {
            title = coinType.fullName().uppercased()
        }
        
        headerView.coinTitleLabel.text = title
        headerView.coinType = coinType
    }
    
    deinit {
        if Constants.Permissions.PrintDeinit {
            print("deinit - "+String(describing: self))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // reloadPagerTabStripView()
    }
    
    private func setupUI() {
        
        let view = UIView.statusView()
        let hexColor = coinType == .emercoin ? Constants.Colors.Status.Base : Constants.Colors.Status.Bitcoin
        let color = UIColor(hexString: hexColor)
        view.backgroundColor = color
        self.view.addSubview(view)
        statusView = view
        
        settings.style.buttonBarBackgroundColor = backgroundColor
        settings.style.buttonBarItemBackgroundColor = backgroundColor
        settings.style.selectedBarBackgroundColor = emerColor
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 18)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = emerColor
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarItemLeftRightMargin = 0
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        settings.style.buttonBarHeight = 57.0
        
        changeCurrentIndexProgressive = {(oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .gray
            
            if (oldCell != nil) && (newCell != nil) {
                let color = self.currentIndex == 1 ? (self.isManaulSelect ? self.bitColor : self.emerColor ) : (self.isManaulSelect ? self.emerColor : self.bitColor )
                self.buttonBarView.selectedBar.backgroundColor = color
                newCell?.label.textColor = color
                self.headerView.coinType = self.currentIndex == 1 ? (self.isManaulSelect ? .bitcoin : .emercoin ) : (self.isManaulSelect ? .emercoin : .bitcoin )
                self.headerView.backgroundColor = color
            
                let statusColor = self.currentIndex == 1 ? (self.isManaulSelect ? self.bitStatusColor : self.emerStausColor ) : (self.isManaulSelect ? self.emerStausColor : self.bitStatusColor )
                    
                if let view = self.statusView {
                    view.backgroundColor = statusColor
                }
                
                self.isManaulSelect = false
            }
        }
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        var controllers:[UIViewController] = []
        
        switch coinsOperation {
        case .send:
            let firstVC = SendCoinsViewController.controller() as! SendCoinsViewController
            firstVC.coinType = coinType
            let secondVC = SendCoinsViewController.controller() as! SendCoinsViewController
            secondVC.coinType = coinType
            firstVC.object = object
            secondVC.object = object
        
            barViewHeightConstraint.constant = 0
            backButton.isHidden = false
            controllers.append(contentsOf: [firstVC,secondVC])
            
        case .recipientAddress:
            let firstVC = RecipientViewController.controller() as! RecipientViewController
            let secondVC = RecipientViewController.controller() as! RecipientViewController
            secondVC.coinType = .bitcoin
            controllers.append(contentsOf: [firstVC,secondVC])
        case .receive:
            let firstVC = ReceiveViewController.controller() as! ReceiveViewController
            let secondVC = ReceiveViewController.controller() as! ReceiveViewController
            secondVC.coinType = .bitcoin
            controllers.append(contentsOf: [firstVC,secondVC])
        case .addresses:
            let firstVC = AddressesViewController.controller() as! AddressesViewController
            let secondVC = AddressesViewController.controller() as! AddressesViewController
            secondVC.coinType = .bitcoin
            backButton.isHidden = false
            controllers.append(contentsOf: [firstVC,secondVC])
        case .history:
            let firstVC = HistoryViewController.controller() as! HistoryViewController
            let secondVC = HistoryViewController.controller() as! HistoryViewController
            secondVC.coinType = .bitcoin
            controllers.append(contentsOf: [firstVC,secondVC])
        case .operations:
            let firstVC = OperationsViewController.controller() as! OperationsViewController
            firstVC.coinType = coinType
            let secondVC = OperationsViewController.controller() as! OperationsViewController
            secondVC.coinType = .bitcoin
            barViewHeightConstraint.constant = 0
            backButton.isHidden = false
            controllers.append(contentsOf: [firstVC,secondVC])
        }
        
        if let firstVC = controllers.first {
            self.firstViewController = firstVC
            
            if let secondVC = controllers.last {
                self.secondViewController = secondVC
            }
        }
        return controllers
    }
    
    @IBAction func back() {
        navigationController?.popViewController(animated: true)
    }
}
