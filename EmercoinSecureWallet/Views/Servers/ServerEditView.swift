//
//  ServerEditView.swift
//  EmercoinSecureWallet
//

import UIKit

class ServerEditView: PopupView {

    @IBOutlet weak var portTextField:BaseTextField!
    @IBOutlet weak var hostTextField:BaseTextField!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var sslSwith:UISwitch!
    @IBOutlet weak var doneButton:YesButton!
    @IBOutlet weak var cancelButton:CancelButton!
    
    var edit:((_ host:String, _ port:Int32, _ ssl:Bool) -> (Void))?
    
    var type:CoinType = .bitcoin {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        portTextField.textChanged = {[weak self](text) in
            self?.validateFields()
        }
        hostTextField.textChanged = {[weak self](text) in
            self?.validateFields()
        }
        
    }
    
    func update(host:String, port:Int32, ssl:Bool) {
        hostTextField.text = host
        portTextField.text = String(port)
        //sslSwith.isOn = ssl
        validateFields()
    }
    
    private func validateFields() {
        
        let port = portTextField.text ?? ""
        let host = hostTextField.text ?? ""
        let isValid = !port.isEmpty && !host.isEmpty
        
        doneButton.isEnabled = isValid
    }
    
    func updateUI() {
        
        if type == .bitcoin {
            let stringColor = Constants.Colors.Coins.Bitcoin
            cancelButton.backgroundColor = UIColor(hexString: Constants.Colors.CancelButton.Bitcoin)
            doneButton.enableColor = stringColor
            //sslSwith.onTintColor = UIColor(hexString: stringColor)
        }
        
        let title = NSLocalizedString("The server for", comment: "") + " \(type.fullName())"
        titleLabel.text = title
        
        doneButton.setTitle(NSLocalizedString("Save", comment: ""), for: .normal)
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        portTextField?.placeholder = NSLocalizedString("Port", comment: "")
        hostTextField?.placeholder = NSLocalizedString("Host", comment: "")
    }
    
    override func doneButtonPressed(sender: UIButton?) {
        
        let host = hostTextField.text ?? ""
        let portString = portTextField.text ?? ""
        let port:Int32 = Int32(portString) ?? 0
        //let ssl = sslSwith.isOn
        
        if edit != nil {
            edit!(host, port, false)
            super.doneButtonPressed(sender: sender)
        }
    }
}
