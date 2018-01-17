//
//  AddressesViewController + TableView.swift
//  EmercoinSecureWallet
//

import Foundation
import UIKit
import SwipeCellKit

extension AddressesViewController:UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = addresses.addresses.count
        return count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "AddressesCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! BaseSwipeTableViewCell
        
        let viewModel = AddressViewModel(address:itemAt(indexPath: indexPath))
        cell.delegate = self
        cell.object = viewModel
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let address = itemAt(indexPath: indexPath)
        UIPasteboard.general.string = address.pubAddress
        
        showCopyView()
    }
    
    internal func itemAt(indexPath:IndexPath) -> Address {
        
        let array = Array(addresses.addresses)
        //let index = getReverseIndex(at: indexPath)
        return array[indexPath.row]
    }
    
    private func getReverseIndex(at indexPath:IndexPath) -> Int {
        let count = addresses.addresses.count
        let index = count - 1 - indexPath.row
        return index
    }
    
    internal func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let editAction = SwipeAction(style: .default, title: " ") { action, indexPath in
            self.addEditContactViewWith(indexPath: indexPath)
        }
        
        editAction.image = UIImage(named: "edit_icon")
        editAction.backgroundColor = UIColor(hexString: "D9743C")
        
        return [editAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .none
        options.transitionStyle = .border
        options.buttonSpacing = -20
        return options
    }
    
    private func addEditContactViewWith(indexPath:IndexPath) {

        let modalVC = loadController(at: "BaseModalViewController", storyboard:"Main") as! BaseModalViewController
        
        let editContactView = loadViewFromXib(name: "Addresses", index: 0,
                                              frame: self.parent!.view.frame) as! EditAddressView
        let address = itemAt(indexPath: indexPath)
        editContactView.viewModel = AddressViewModel(address: address)

        let index = indexPath.row//getReverseIndex(at: indexPath)

        editContactView.add = ({[weak self] (name) in
            self?.addresses.update(at: name, index: index)
            self?.reloadRows(at: [indexPath])
        })
        editContactView.cancel = ({
            self.reloadRows(at: [indexPath])
        })
        editContactView.coinType = coinType
        modalVC.modalView = editContactView
        
        self.present(modalVC, animated: true, completion: nil)
//        self.parent?.view.addSubview(editContactView)
    }
    
    private func reloadRows(at indexPaths:[IndexPath]) {
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: indexPaths, with: .none)
        self.tableView.endUpdates()
    }
}
