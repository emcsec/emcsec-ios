//
//  ChangeAddressesViewController.swift
//  EmercoinSecureWallet
//

import UIKit

class ChangeAddressesViewController: BaseViewController {

    @IBOutlet internal weak var titleLabel:UILabel!
    @IBOutlet internal weak var bitcoinLabel:UILabel!
    @IBOutlet internal weak var bitcoinAddressTitleLabel:UILabel!
    @IBOutlet internal weak var emercoinAddressTitleLabel:UILabel!
    @IBOutlet internal weak var emercoineLabel:UILabel!
    
    @IBOutlet internal weak var emercoinAddressLabel:UILabel!
    @IBOutlet internal weak var bitcoinAddressLabel:UILabel!
    
    private var addresses = Addresses()
    private var emercoinAddress:Address?
    private var bitcoinAddress:Address?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupController()
    }
    
    override func setupUI() {
        super.setupUI()
        
        titleLabel?.text = NSLocalizedString("Addresses for change", comment: "").uppercased()
        bitcoinLabel?.text = String(format:"%@ %@", NSLocalizedString("Address for change in", comment: ""), CoinType.bitcoin.fullName())
        emercoineLabel?.text = String(format:"%@ %@", NSLocalizedString("Address for change in", comment: ""), CoinType.emercoin.fullName())
        
        bitcoinAddressTitleLabel.text = NSLocalizedString("Address", comment: "") + ":"
        emercoinAddressTitleLabel.text = NSLocalizedString("Address", comment: "") + ":"
    }
    
    private func setupController() {
        
        emercoinAddress = addresses.addressForChange(at: .emercoin)
        bitcoinAddress = addresses.addressForChange(at: .bitcoin)
        
        updateUI()
    }
    
    override class func storyboardName() -> String {
        return "Settings"
    }
    
    private func updateUI() {
        
        guard let emercoinAddress = self.emercoinAddress,
              let bitcoinAddress = self.bitcoinAddress else { return }
        
        updateUI(at: emercoinAddress)
        updateUI(at: bitcoinAddress)
    }
    
    private func updateUI(at address:Address) {
        
        let addressPub = address.pubAddress
        
        if address.type == "Emercoin" {
            emercoinAddressLabel.text = addressPub
        } else {
            bitcoinAddressLabel.text = addressPub
        }
    }

    @IBAction func editButtonPressed(sender:UIButton) {
        
        let type:CoinType = sender.tag == 0 ? .emercoin : .bitcoin
        
        let view = loadViewFromXib(name: "ChangeAddresses", index: 0) as! ChangeAddressView2
        view.frame = self.view.frame
        view.type = type
        view.edit = { address in
                self.addresses.changeAddressForChange(at: address, type: type)
                self.setupController()
        }
        self.view.addSubview(view)
    }
}
