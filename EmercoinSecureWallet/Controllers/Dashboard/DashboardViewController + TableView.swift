//
//  DashboardViewController + TableView.swift
//  EmercoinSecureWallet
//

import Foundation
import UIKit

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
  
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height = 0.0
        
        let isSelectedRow = selectedRows.contains(indexPath)
        
        switch indexPath.row {
        case 0:height = Constants.CellHeights.DashboardCell.Collapsed
        if isSelectedRow {
            let coinsHeight = Constants.CellHeights.DashboardCell.MoneyView * Double(coins.count)
            height += coinsHeight
            }
        default:break
        }
        
        return CGFloat(height)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let idenitfier = "DashboardCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: idenitfier, for: indexPath) as! BaseTableViewCell
        
        cell.indexPath = indexPath
        cell.pressedCell = {[weak self] (selIndexPath) in
            self?.expandedCell(indexPath: selIndexPath)
        }
        
        if indexPath.row == 0 {
            
            let moneyCell = cell as! DashboardCell
            moneyCell.pressed = {[weak self] (type) in
                self?.showOperationController(at: type)
            }
            cell.isExpanded = selectedRows.contains(indexPath)
            cell.object = coins
        }
        
        return cell
    }
    
    private func showOperationController(at type:CoinType) {
        let controller = loadController(at: "CoinsContainerViewController", storyboard: "CoinsOperation") as! CoinsContainerViewController
        controller.coinsOperation = .operations
        controller.coinType = type
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func expandedCell(indexPath:IndexPath) {
        
        if !selectedRows.contains(indexPath) {
            selectedRows.append(indexPath)
        } else {
            selectedRows.remove(object: indexPath)
        }
        
        tableView.reload()
    }
}
