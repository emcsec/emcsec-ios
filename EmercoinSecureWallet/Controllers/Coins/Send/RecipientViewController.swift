//
//  RecipientAddressViewController.swift
//  EmercoinOne
//

import UIKit

class RecipientViewController: BaseViewController, IndicatorInfoProvider {
    
    @IBOutlet internal weak var qrCodeButton:UIButton!
    @IBOutlet internal weak var recipiantsList:UIButton!
    @IBOutlet internal weak var enterAddressButton:UIButton!
    
    var coinType:CoinType = .emercoin
    
    override class func storyboardName() -> String {
        return "CoinsOperation"
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title:coinType.fullName())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func setupUI() {
        super.setupUI()
        
        qrCodeButton.setTitle(NSLocalizedString("Scan QR-Code", comment: ""), for: .normal)
        recipiantsList.setTitle(NSLocalizedString("List of recipients", comment: ""), for: .normal)
        enterAddressButton.setTitle(NSLocalizedString("Enter an address", comment: ""), for: .normal)
        
        statusBarView?.isHidden = true
    }
    
    internal func updateController() {
        
        if let data = object as? [String : Any] {
            
            if (data["amount"] as? String) != nil  {
                
                showSendController(at: data)
            }
            
            object = nil
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        if let data = object as? [String : Any] {
//
//            if (data["amount"] as? String) != nil {
//                showSendController(at: data)
//            }
//            object = nil
//        }
        
        //updateController()
    }
    
    @IBAction func qrCodeButtonPressed(sender:UIButton) {
        showScanQRCodeController()
    }
    
    @IBAction func listButtonPressed(sender:UIButton) {
        print("listButtonPressed")
        showAddressBookController()
    }
    
    @IBAction func enterButtonPressed(sender:UIButton) {
        showSendController(at:nil)
    }
    
    func showSendController(at data:[String:Any]?) {
    
       // let controller = SendCoinsViewController.controller() as! SendCoinsViewController
       let controller = loadController(at: "CoinsContainerViewController", storyboard: "CoinsOperation") as! CoinsContainerViewController

        controller.coinsOperation = .send
        controller.coinType = coinType
        controller.object = data as AnyObject
        push(at: controller)
    }
    
    private func showAddressBookController() {

        let controller = ContactsViewController.controller() as! ContactsViewController
        controller.selectedAddress = {(address)in
            var dict:[String:Any] = [:]
            dict["address"] = address
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.showSendController(at: dict)
            }
        }
        controller.coinType = coinType
        push(at: controller)
    }
    
    private func showScanQRCodeController() {
        
        let controller = ScanQRCodeController.controller() as! ScanQRCodeController
        controller.scanned = {(data)in
            
            let dict = data as! [String:Any]
            let name = dict["name"] as? String
            self.coinType = (name == "bitcoin") ? .bitcoin : .emercoin
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.showSendController(at: dict)
            }
        }
        present(controller, animated: true, completion: nil)
        //push(at: controller)
    }
    
    private func push(at controller:UIViewController) {
        
        navigationController?.pushViewController(controller, animated: true)
    }
}
