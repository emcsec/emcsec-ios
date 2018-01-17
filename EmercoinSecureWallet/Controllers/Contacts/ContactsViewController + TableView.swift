//
//  ContactsViewController + TableView.swift
//  EmercoinSecureWallet
//

import UIKit
import SwipeCellKit

extension ContactsViewController {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = contacts.contacts.count
        return count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "ContactCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! BaseSwipeTableViewCell
        
        let viewModel = ContactViewModel(contact: itemAt(indexPath: indexPath))
        cell.object = viewModel
        cell.delegate = self
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = itemAt(indexPath: indexPath)
        if selectedAddress != nil {
            selectedAddress!(item.address)
            self.back()
        }
    }
    
    internal func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .default, title: " ") { action, indexPath in
            self.addDeleteContactViewWith(indexPath: indexPath)
        }
        
        let editAction = SwipeAction(style: .default, title: " ") { action, indexPath in
            self.addEditContactViewWith(indexPath: indexPath)
        }
        
        deleteAction.image = UIImage(named: "delete_icon")
        deleteAction.backgroundColor = UIColor(hexString: "DA3975")
        editAction.image = UIImage(named: "edit_icon")
        editAction.backgroundColor = UIColor(hexString: "D9743C")
        
        return [deleteAction,editAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .none
        options.transitionStyle = .border
        options.buttonSpacing = -20
        return options
    }
    
    private func removeCellAt(indexPath:IndexPath) {
        
        let item = itemAt(indexPath: indexPath)
        contacts.remove(at: item)
        
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .top)
        tableView.endUpdates()
        self.updateUI()
    }
    
    private func addDeleteContactViewWith(indexPath:IndexPath) {
        
        let deleteContactView = loadViewFromXib(name: "Contacts", index: 0,
                                                frame: self.parent!.view.frame) as! DeleteContactView
        deleteContactView.delete = ({
            self.removeCellAt(indexPath: indexPath)
        } as (() -> (Void)))
        
        deleteContactView.cancel = ({
            self.reloadRows(at: [indexPath])
        })
        deleteContactView.coinType = coinType
        
        self.parent?.view.addSubview(deleteContactView)
    }
    
    private func addEditContactViewWith(indexPath:IndexPath) {
        
        let modalVC = loadController(at: "BaseModalViewController", storyboard:"Main") as! BaseModalViewController
        
        let editContactView = loadViewFromXib(name: "Contacts", index: 1,
                                              frame: self.parent!.view.frame) as! AddContactView
        let contact = itemAt(indexPath: indexPath)
        editContactView.viewModel = ContactViewModel(contact: contact)
        
        editContactView.add = ({(name, address) in
            
            self.contacts.update(at: name, address: address, index: indexPath.row)
            self.reloadRows(at: [indexPath])
        })
        editContactView.cancel = ({
            self.reloadRows(at: [indexPath])
        })
        
        editContactView.coinType = coinType
    
        modalVC.modalView = editContactView
        self.present(modalVC, animated: true, completion: nil)
    }
    
    private func reloadRows(at indexPaths:[IndexPath]) {
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: indexPaths, with: .none)
        self.tableView.endUpdates()
    }
    
    private func itemAt(indexPath:IndexPath) -> Contact {
        return contacts.contacts[indexPath.row]
    }
}
