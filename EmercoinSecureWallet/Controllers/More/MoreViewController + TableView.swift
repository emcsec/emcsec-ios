//
//  MoreViewController + TableView.swift
//  EmercoinSecureWallet
//

import Foundation
import UIKit

enum MoreMenuType:Int {
    case addresses = 0
    case settings = 1
    case about = 2
    case logout = 3
}

extension MoreViewController:UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let identifier = "MoreCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! BaseTableViewCell
        cell.object = itemAt(indexPath: indexPath)
        
        if indexPath.row == MoreMenuType.logout.rawValue {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    private func itemAt(indexPath:IndexPath) -> MenuItem {
        return menuItems[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        
        if let type = MoreMenuType(rawValue: row) {
            
            switch type {
                case .logout:showLogoutView()
                case .addresses:showAddressesController()
                case .settings:showSettingsController()
                //case .legal:showLegalController()
                case .about:showAboutController()
            }
        }
    }
    
    func showLogoutView() {
        
        let logoutView = loadViewFromXib(name: "Operations", index: 4) as! LogoutView
        logoutView.done = {
            AppManager.sharedInstance.logout()
        }
        
        if let rootView = RootViewController()?.view {
            logoutView.frame = rootView.frame
            rootView.addSubview(logoutView)
        }
    }
    
    func showAddressesController(at data:AnyObject? = nil) {
        
        let vc = loadController(at: "CoinsContainerViewController",
                                storyboard: "CoinsOperation") as! CoinsContainerViewController
        vc.coinsOperation = .addresses
        vc.object = data
        pushController(at: vc)
    }
    
    func showAboutController() {
        let controller = AboutViewController.controller()
        pushController(at: controller)
    }
    
    func showSettingsController() {
        let controller = SettingsViewController.controller()
        pushController(at: controller)
    }
    
    func showLegalController() {
        let controller = LicensiesViewController.controller()
        pushController(at: controller)
    }
    
    func pushController(at controller:UIViewController) {
        navigationController?.pushViewController(controller, animated: true)
    }
}
