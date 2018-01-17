//
//  InitialViewController.swift
//  EmercoinSecureWallet
//

import UIKit

class InitialViewController: BaseViewController {

    @IBOutlet private weak var generateButton:UIButton!
    @IBOutlet private weak var restoreButton:UIButton!
    @IBOutlet private weak var serversButton:UIButton!
    @IBOutlet private weak var mobileLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Settings.baseInit()
    }
    
    override func setupUI() {
        super.setupUI()
        
        generateButton.setTitle(NSLocalizedString("Generate a new wallet", comment: ""), for: .normal)
        restoreButton.setTitle(NSLocalizedString("Restore your wallet", comment: ""), for: .normal)
        serversButton.setTitle(NSLocalizedString("Advanced server settings", comment: ""), for: .normal)
        mobileLabel?.text = NSLocalizedString("mobile wallet", comment: "").uppercased()
    }

    override class func storyboardName() -> String {
        return "Initial"
    }
    
    @IBAction func seedGenerationButtonPressed() {
        let controller = SeedViewController.controller()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func restoreButtonPressed() {
        let controller = RestoreViewController.controller()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func serversButtonPressed() {
        let controller = ServersViewController.controller()
        navigationController?.pushViewController(controller, animated: true)
    }

}
