//
//  LicensiesViewController + TableView.swift
//  EmercoinBasic
//

import UIKit

extension LicensiesViewController {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 1
        
        if let licensies = licensies {
            count += licensies.licensies.count
        }
        
        return count
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let row = indexPath.row
        
        let identifier = row == 0 ? "LicenseLogoCell" : "LicenseCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! BaseTableViewCell
        
        if row > 0 {
            if let license = item(at: row - 1) {
                cell.object = LicenseViewModel(license: license)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row > 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row > 0 {
            let cell = tableView.cellForRow(at: indexPath) as! BaseTableViewCell
            
            let controller = LegalViewController.controller() as! LegalViewController
            controller.viewModel = cell.object as? LicenseViewModel
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    private func item(at index:Int) -> License? {
        
        var license:License? = nil
        
        if let licensies = licensies {
            license = licensies.licensies[index]
        }
        
        return license
    }
}
