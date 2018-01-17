
//
//  HistoryViewController + TableView.swift
//  EmercoinOne
//

import UIKit

extension HistoryViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let isConfirmed = section  != 0
        let count = history.transactions(confirmed: isConfirmed).count
        return count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cellIdentifier = "HistoryCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! BaseTableViewCell
        let item = itemAt(indexPath: indexPath)
        let viewModel = HistoryTransactionViewModel(historyTransaction: item)
        cell.object = viewModel
    
        return cell
    }
    
    internal func itemAt(indexPath:IndexPath) -> HistoryTransaction {
        
        let isConfirmed = indexPath.section  != 0
        var transactions = history.transactions(confirmed: isConfirmed)
        transactions = transactions.sorted(byKeyPath: "timeInterval", ascending: false)
        return transactions[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedIndexPath = indexPath
        
        let cell = tableView.cellForRow(at: indexPath) as? BaseTableViewCell
        let item = cell?.object
        
        showTransactionDetailView(at:item as! HistoryTransactionViewModel)
    }
}
