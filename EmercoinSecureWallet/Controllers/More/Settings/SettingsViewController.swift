//
//  SettingsViewController.swift
//  EmercoinSecureWallet
//

import UIKit
import RealmSwift

class SettingsViewController: BaseViewController {

    @IBOutlet internal weak var titleLabel:UILabel!
    
    @IBOutlet internal weak var currencyButton:UIButton!
    @IBOutlet internal weak var serversLabel:UILabel!
    @IBOutlet internal weak var currencyLabel:UILabel!
    @IBOutlet internal weak var addressesLabel:UILabel!
    @IBOutlet internal weak var currencyTextLabel:UILabel!
    @IBOutlet internal weak var pinCodeLabel:UILabel!
    var currencyDropDown:DropDown?
    
    @IBOutlet weak var touchIDState:UISwitch!
    @IBOutlet weak var pinState:UISwitch!
    @IBOutlet weak var overlayPinView:UIView!
    
    private let wallet = AppManager.sharedInstance.wallet
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCurrencyDropDown()
        updateUI()
    }
    
    override func setupUI() {
        super.setupUI()
        
        titleLabel?.text = NSLocalizedString("Settings", comment: "").uppercased() 
        currencyTextLabel?.text = NSLocalizedString("Сurrency", comment: "")
        addressesLabel?.text = NSLocalizedString("Addresses for change", comment: "")
        serversLabel?.text = NSLocalizedString("Servers", comment: "")
        pinCodeLabel?.text = NSLocalizedString("Pin Code", comment: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupDropDownUI()
    }
    
    override class func storyboardName() -> String {
        return "Settings"
    }
    
    private func updateUI() {
        
        if let pinTouchID = Settings.pinTouchID {
            overlayPinView.isHidden = !pinTouchID.isEnabledTouchID
            touchIDState.isOn = pinTouchID.isEnabledTouchID
            pinState.isOn = pinTouchID.isEnabledPin
            touchIDState.isEnabled = pinTouchID.isEnabledPin
            //pinState.isEnabled = !pinTouchID.pin.isEmpty
        }
    }
    
    @IBAction func pinSwithPressed(sender:UISwitch) {
        
        let isPinEnable = sender.isOn
        
        if let pinTouchID = Settings.pinTouchID {
            
            let helper = PinTouchIDHelper()
            helper.fromController = self
            
            enableTabBar(at:false)
            helper.cancel = {
                self.pinState.setOn(!isPinEnable, animated: true)
                showTabBar(at: true)
            } as (() -> (Void))
            
            if pinTouchID.pin.isEmpty {
                
                helper.isNeedSetPin = true
                helper.startProtection()
                helper.done = {
                    self.updateUI()
                    self.enableTabBar(at:true)
                }
            } else {
                
                helper.enterPin = {
                    if let pinTouchID = Settings.pinTouchID {
                        let realm = try! Realm()
                        try! realm.write {
                            pinTouchID.isEnabledPin = isPinEnable
                            
                            if !isPinEnable {
                                pinTouchID.isEnabledTouchID = false
                            }
                            
                            self.updateUI()
                        }
                    }
                    self.enableTabBar(at:true)
                    } as (() -> (Void))
                
                helper.showPinView(at: .enable)
            }
        }
    }
    
    private func enableTabBar(at enable:Bool) {
        showTabBar(at: enable)
        isShowingPinView(at: !enable)
    }
    
    @IBAction func touchIDSwitchPressed(sender:UISwitch) {
        if let pinTouchID = Settings.pinTouchID {
            let realm = try! Realm()
            try! realm.write {
                pinTouchID.isEnabledTouchID = sender.isOn
                self.updateUI()
            }
        }
    }
    
    internal func setupDropDownUI() {
        
        let appearance = DropDown.appearance()
        appearance.selectionBackgroundColor = currencyLabel.textColor
        appearance.cellHeight = currencyButton.bounds.height + 5
        appearance.textFont = UIFont.systemFont(ofSize: 16)
    }
    
    internal func setupCurrencyDropDown() {
        
        currencyDropDown = DropDown()
        currencyDropDown?.anchorView = currencyButton
        
        let dataSource = ["USD","EUR","CNY","RUR"]
        
        currencyLabel.text = wallet.currencyType.description()
        
        currencyDropDown?.dataSource = dataSource
        
        currencyDropDown?.selectionAction = { [unowned self] (index, item) in
            self.currencyLabel.text = item
            
            
            let currency:CurrencyType = CurrencyType(rawValue: index) ?? .usd
            self.wallet.currencyType = currency
        }
        
        currencyDropDown?.bottomOffset = CGPoint(x: 0, y: currencyButton.bounds.height)
    }
    
    @IBAction func currencyButtonPressed() {
        
        currencyDropDown?.show()
    }
    
    @IBAction func serversButtonPressed() {
        showServersController()
    }
    
    @IBAction func changeAddressesButtonPressed() {
        showChangeAddressesController()
    }
    
    private func showChangeAddressesController() {
        let controller = ChangeAddressesViewController.controller()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func showServersController() {
        let controller = ServersViewController.controller()
        navigationController?.pushViewController(controller, animated: true)
    }
}
