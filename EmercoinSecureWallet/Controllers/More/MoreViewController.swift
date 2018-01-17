//
//  MoreViewController.swift
//  EmercoinSecureWallet
//

import UIKit

class MoreViewController: BaseViewController {

    @IBOutlet internal weak var tableView:UITableView!
    @IBOutlet internal weak var versionLabel:UILabel!
    @IBOutlet internal weak var titleLabel:UILabel!
    
    var menuItems:[MenuItem] = []
    
    override class func storyboardName() -> String {
        return "More"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        tabBarObject = TabBarObject(title: Constants.TabTitle.More,
                                    imageName: Constants.TabImage.More)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.baseSetup()
        setupMenu()
    }
    
    override func setupUI() {
        super.setupUI()
        
        let version = bundleVersion()
        versionLabel.text = String(format:"%@ %@",NSLocalizedString("Version", comment: ""), version)
        titleLabel?.text = NSLocalizedString("emercoin secure wallet", comment: "").uppercased()
    }
    
    private func setupMenu() {
    
        let addressesMenuItem = MenuItem(title: Constants.Menu.Addresses.Title,
                                        image: Constants.Menu.Addresses.Image)
        let settingsMenuItem = MenuItem(title: Constants.Menu.Settings.Title,
                                        image: Constants.Menu.Settings.Image)
        let avoutMenuItem = MenuItem(title: Constants.Menu.About.Title,
                                     image: Constants.Menu.About.Image)
        let exitMenuItem = MenuItem(title: Constants.Menu.Exit.Title,
                                    image: Constants.Menu.Exit.Image)
        
        menuItems = [addressesMenuItem,settingsMenuItem,avoutMenuItem,exitMenuItem]
    }
}
