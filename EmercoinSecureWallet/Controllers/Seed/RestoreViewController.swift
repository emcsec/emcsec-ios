//
//  RestoreViewController.swift
//  EmercoinSecureWallet
//

import UIKit

class RestoreViewController: BaseViewController {

    @IBOutlet private weak var mainView:UIView!
    @IBOutlet private weak var backButton:UIButton!
    @IBOutlet private weak var titleLabel:UILabel!
    
    private weak var validationView:SeedValidationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.showValidationView()
        }
    }
    
    override func setupUI() {
        super.setupUI()
        
        let title = NSLocalizedString("Restore your wallet", comment: "").uppercased()
        titleLabel.text = title
    }

    override class func storyboardName() -> String {
        return "Seed"
    }
    
    private func showMainController() {
        AppManager.sharedInstance.isNeedLoadAllData = true
        Router.sharedInstance.showMainController()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    private func showValidationView() {
        
        let view = loadViewFromXib(name: "Seed", index: 1, frame: mainView.bounds) as! SeedValidationView
        
        view.nextPressed = { [weak self] in
            self?.restoreButtonPressed(at: view.words.joined(separator: " "))
        }
        
        view.validationType = .repair
        mainView.addSubview(view)
        validationView = view
    }
    
    private func restoreButtonPressed(at seed:String) {
        
        DispatchQueue.global(qos: .background).async {
            
            BitcoinWalletHelper.generateAddresses(at: seed, completion: {[weak self] data, success in
                DispatchQueue.main.async {
                    if success == false {
                        self?.showErrorView()
                        self?.validationView?.showIndicatorView(at: false)
                        self?.validationView?.enableNextButton(at: true)
                    } else if let addresses = data {
                        let addressesData = Addresses()
                        addressesData.add(addresses: addresses)
                        self?.backButton.isHidden = true
                        self?.showDoneView()
                    }
                }
            })
        }
    }
    
    private func showDoneView() {
        
        let view = loadViewFromXib(name: "Seed", index: 2, frame: mainView.bounds) as! SeedDoneView
        
        view.done = { [weak self] in
            
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                 self?.showMainController()
            })
        }
        
        view.type = .repair
        
        self.mainView.addSubview(view)
    }
    
    private func showErrorView() {
        
        let error = NSError(domain: NSLocalizedString("Wrong seed", comment: ""), code: -1, userInfo: nil)
        showErroAlert(error: error)
    }
}
