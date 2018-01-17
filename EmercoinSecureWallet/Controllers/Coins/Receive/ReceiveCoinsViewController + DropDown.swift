//
//  GetCoinsViewController + DropDown.swift
//  EmercoinOne
//

import UIKit

extension ReceiveViewController {
    
    internal func setupDropDown() {
        
        updateAddressBook()
        
        setupDataSource()
        
        dropDown = DropDown()
        dropDown?.anchorView = dropDownButton
        
        setupDataSource()
        
        dropDown?.cellNib = UINib(nibName: "ReceiveSelectCell", bundle: nil)
        
        dropDown?.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? ReceiveSelectCell else { return }
            
            let addresses = self.addresses.addresses
            
            if index < addresses.count {
                let address = self.addresses.addresses[index]
                cell.optionLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
                cell.optionLabel.text = address.pubAddress
                cell.nameLabel.font = UIFont.systemFont(ofSize: 17)
                cell.nameLabel.text = address.name
            }
        }
        
        dropDown?.selectionAction = { [weak self] (index, item) in
            self?.addressLabel.text = item
            self?.address = self?.addresses.addresses[index].pubAddress ?? ""
            self?.generateQRCode(at:self?.address ?? "")
        }
        
        dropDown?.bottomOffset = CGPoint(x: 0, y: dropDownButton.bounds.height)
        
        setupDropDownUI()
    }
    
    internal func setupDataSource() {
        
        self.dropDown?.dataSource = addresses.publicAdresses()
        
        let firstAddress = addresses.publicAdresses().first ?? ""
        self.address = firstAddress
        
        self.addressLabel.text = firstAddress
        self.dropDown?.reloadAllComponents()
    }
    
    internal func setupDropDownUI() {
        
        let appearance = DropDown.appearance()
        appearance.selectionBackgroundColor = coinSignLabel.textColor
    
        appearance.cellHeight = 44
        //appearance.textFont = UIFont.systemFont(ofSize: 18)
    }
    
    @IBAction func dropButtonPressed() {
        
        dropDown?.show()
    }
}
