//
//  AddressesViewController.swift
//  EmercoinSecureWallet
//

import UIKit
import SwipeCellKit

class AddressesViewController: BaseViewController, IndicatorInfoProvider {
    
    @IBOutlet internal weak var tableView:UITableView!
    
   // @IBOutlet internal weak var tableView:UITableView!
    
    var coinType:CoinType = .emercoin
    var addresses = Addresses()
    
    override class func storyboardName() -> String {
        return "CoinsOperation"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addresses.type = coinType
        
        tableView.baseSetup()
    }
    
    override func setupUI() {
        super.setupUI()
        
        hideStatusBar()
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title:coinType.fullName())
    }
    
}
