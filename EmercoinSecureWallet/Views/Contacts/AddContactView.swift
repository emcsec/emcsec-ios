//
//  AddContactView.swift
//  EmercoinOne
//

import UIKit

class AddContactView: PopupView {

    @IBOutlet weak var nameTextField:BaseTextField!
    @IBOutlet weak var addressTextField:BaseTextField!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var doneButton:YesButton!
    @IBOutlet weak var cancelButton:CancelButton!
    
    var add:((_ name:String, _ address:String) -> (Void))?
    
    var viewModel:ContactViewModel? {
        didSet {
            updateUI()
        }
    }
    
    var coinType:CoinType = .emercoin {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameTextField.textChanged = {[weak self](text) in
            self?.validateFields()
        }
        addressTextField.textChanged = {[weak self](text) in
            self?.validateFields()
        }
        
    }
    
    private func validateFields() {
        
        let address = addressTextField.text ?? ""
        
        let isEmercoin = coinType == .emercoin
        
        let isValidAddress = isEmercoin ? address.validEmercoinAddress() : address.validBitcoinAddress()
        
        doneButton.isEnabled = isValidAddress
    }
    
    private func updateUI() {
        
        if coinType == .bitcoin {
            cancelButton.backgroundColor = UIColor(hexString: Constants.Colors.CancelButton.Bitcoin)
            doneButton.enableColor = Constants.Colors.Coins.Bitcoin
        }
        
        var title = NSLocalizedString("New contact", comment: "")
        var doneTitle = NSLocalizedString("Add", comment: "")
        
        if viewModel != nil {
            title = NSLocalizedString("Edit contact", comment: "")
            doneTitle = NSLocalizedString("Save", comment: "")
            nameTextField.text = viewModel?.name
            addressTextField.text = viewModel?.address
            doneButton.isEnabled = true
        }
        
        doneButton.setTitle(doneTitle, for: .normal)
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        nameTextField?.placeholder = NSLocalizedString("Label", comment: "")
        addressTextField?.placeholder = NSLocalizedString("Address", comment: "")
        
        titleLabel.text = title
    }
    
    @IBAction override func doneButtonPressed(sender:UIButton?) {
        
        let name = nameTextField.text
        let address = addressTextField.text
        
        if add != nil {
            add!(name!, address!)
        } else {
            return
        }
        super.doneButtonPressed(sender: sender)
    }

}
