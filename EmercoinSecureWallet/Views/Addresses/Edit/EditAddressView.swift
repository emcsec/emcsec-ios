//
//  AddAddressView.swift
//  EmercoinOne
//

import UIKit

class EditAddressView: PopupView {

    @IBOutlet weak var nameTextField:UITextField!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var doneButton:YesButton!
    @IBOutlet weak var cancelButton:CancelButton!
    
    var add:((_ name:String) -> (Void))?
    
    var viewModel:AddressViewModel? {
        didSet {
            updateUI()
        }
    }
    
    var coinType:CoinType = .emercoin {
        didSet {
            updateUI()
        }
    }
    
    internal func updateUI() {
        
        if coinType == .bitcoin {
            cancelButton.backgroundColor = UIColor(hexString: Constants.Colors.CancelButton.Bitcoin)
            doneButton.backgroundColor = UIColor(hexString: Constants.Colors.Coins.Bitcoin)
        }
        
        var title = NSLocalizedString("New address", comment: "")
        var doneTitle = NSLocalizedString("Add", comment: "")
        if viewModel != nil {
            title = NSLocalizedString("Edit address", comment: "")
            doneTitle = NSLocalizedString("Save", comment: "")
            nameTextField.text = viewModel?.name
        }
        
        titleLabel.text = title
        doneButton.setTitle(doneTitle, for: .normal)
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        nameTextField?.placeholder = NSLocalizedString("Label", comment: "")
    }
    
    @IBAction override func doneButtonPressed(sender:UIButton?) {
        
        let name = nameTextField.text ?? ""
        
        if add != nil  {
            add!(name)
        }
        
        super.doneButtonPressed(sender: sender)
    }
}
