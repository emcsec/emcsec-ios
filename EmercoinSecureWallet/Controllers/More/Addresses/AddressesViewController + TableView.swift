//
//  AddressesViewController + TableView.swift
//  EmercoinSecureWallet
//

import Foundation
import UIKit
import SwipeCellKit

enum AddressOperationType:Int {
    case edit = 0
    case export = 1
}

enum AddressSectionType:Int {
    case my = 0
    case change = 1
}

extension AddressesViewController:UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = section == 0 ? addresses.addresses.count : addresses.changeAddresses.count
        return count
    }
    
    internal func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = section == AddressSectionType.my.rawValue ? NSLocalizedString("My Addresses", comment: "") :
            NSLocalizedString("Addresses for change", comment: "")
        return title
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "AddressesCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! BaseSwipeTableViewCell
        
        let viewModel = AddressViewModel(address:itemAt(indexPath: indexPath))
        cell.delegate = self
        cell.object = viewModel
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let addressCell = cell as! AddressesCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let address = itemAt(indexPath: indexPath)
        UIPasteboard.general.string = address.pubAddress
        
        showCopyView()
    }
    
    internal func itemAt(indexPath:IndexPath) -> Address {
        
        let array = indexPath.section == AddressSectionType.my.rawValue ? Array(addresses.addresses) :
            Array(addresses.changeAddresses)
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
        
        let isChange = indexPath.section == AddressSectionType.change.rawValue
        
        var actions:[SwipeAction] = []
        
        if !isChange {
            
            let editAction = SwipeAction(style: .default, title: " ") { action, indexPath in
                self.addAddressView(at: indexPath, addressOperationType: .edit)
            }
            editAction.image = UIImage(named: "edit_icon")
            editAction.backgroundColor = UIColor(hexString: "D9743C")
            actions.append(editAction)
        }
        
        let exportAction = SwipeAction(style: .default, title: " ") { action, indexPath in
            self.addAddressView(at: indexPath, addressOperationType: .export)
        }
        
        exportAction.image = UIImage(named: "export_icon")
        exportAction.backgroundColor = UIColor(hexString: "848484")
        actions.append(exportAction)
        
        return actions
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .none
        options.transitionStyle = .border
        options.buttonSpacing = -20
        return options
    }
    
    private func addAddressView(at indexPath:IndexPath, addressOperationType:AddressOperationType) {
        
        let modalVC = loadController(at: "BaseModalViewController", storyboard:"Main") as! BaseModalViewController
        let address = itemAt(indexPath: indexPath)
        let viewModel = AddressViewModel(address: address)
        
        if addressOperationType == .edit {
            
            let editContactView = getAddressView(at: addressOperationType.rawValue) as! EditAddressView
            editContactView.viewModel = viewModel
            
            let index = indexPath.row//getReverseIndex(at: indexPath)
            let isChange = indexPath.section == AddressSectionType.change.rawValue
            editContactView.add = ({[weak self] (name) in
                self?.addresses.update(at: name, index: index, isChange: isChange)
            })
            editContactView.coinType = coinType
            modalVC.modalView = editContactView
            
        } else {
            
            let exportAddressView = getAddressView(at: addressOperationType.rawValue) as! ExportAddressView
            
            exportAddressView.viewModel = viewModel
            exportAddressView.coinType = coinType
            modalVC.modalView = exportAddressView
        }
        
        modalVC.close = ({[weak self] in
            self?.reloadRows(at: [indexPath])
        })
        
        self.present(modalVC, animated: true, completion: nil)
    }
    
    private func getAddressView(at index:Int) -> UIView {
        
        return loadViewFromXib(name: "Addresses", index: index,
                               frame: self.parent!.view.frame)
    }
    
    private func reloadRows(at indexPaths:[IndexPath]) {
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: indexPaths, with: .none)
        self.tableView.endUpdates()
    }
}
