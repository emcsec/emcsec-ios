//
//  OperationsViewController.swift
//  EmercoinOne
//

import UIKit

class OperationsViewController: BaseViewController, IndicatorInfoProvider {

    @IBOutlet internal weak var titleLabel:UILabel!
    @IBOutlet internal weak var sendButton:UIButton!
    @IBOutlet internal weak var receiveButton:UIButton!
    @IBOutlet internal weak var historyButton:UIButton!
    @IBOutlet internal weak var addressesButton:UIButton!
    
    var coinType:CoinType = .bitcoin

    override class func storyboardName() -> String {
        return "CoinsOperation"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupUI() {
        hideStatusBar()
        
        titleLabel?.text = NSLocalizedString("Operations", comment: "")
        sendButton.setTitle(NSLocalizedString("Send Coins", comment: ""), for: .normal)
        receiveButton.setTitle(NSLocalizedString("Receive Coins", comment: ""), for: .normal)
        historyButton.setTitle(NSLocalizedString("History", comment: ""), for: .normal)
        addressesButton.setTitle(NSLocalizedString("My Addresses", comment: ""), for: .normal)
        
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Operations")
    }
    
    @IBAction func sendButtonPressed(sender:UIButton) {
        showController(at: .recipientAddress)
    }
    
    @IBAction func myAddressButtonPressed(sender:UIButton) {
        showController(at: .addresses)
    }
    
    @IBAction func receiveButtonPressed(sender:UIButton) {
        showController(at: .receive)
    }
    
    @IBAction func historyButtonPressed(sender:UIButton) {
        showController(at: .history)
    }
    
    private func showController(at type:CoinsOperation) {
        
        let tabBar = Router.sharedInstance.tabBar
        
        var data = [String:Any]()
        data["coin"] = coinType
        
        tabBar?.showController(at: data as AnyObject, type: type)
    }
}
