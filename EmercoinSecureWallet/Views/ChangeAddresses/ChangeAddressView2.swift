//
//  ChangeAddressView2.swift
//  EmercoinSecureWallet
//

import UIKit

class ChangeAddressView2: PopupView, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var doneButton:YesButton!
    @IBOutlet weak var cancelButton:CancelButton!
    @IBOutlet weak var tableView:UITableView!
    
    var edit:((_ address:String) -> (Void))?
    private var color:UIColor = .lightGray
    
    private var selectedAddress = ""
    
    private var addresses = Addresses()
    
    var type:CoinType = .bitcoin {
        didSet {
            updateUI()
            setupAddress()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let nib = UINib.init(nibName: "ChangeAddressCell", bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: "ChangeAddressCell")
        tableView.hideEmtyCells()
    }
    
    private func setupAddress() {
        
        addresses.type = type
        
        if let address = addresses.addressForChange(at: type) {
            selectedAddress = address.pubAddress
        }
    }
    
    func updateUI() {
        
        if type == .bitcoin {
            let stringColor = Constants.Colors.Coins.Bitcoin
            self.color = UIColor(hexString: stringColor)
            cancelButton.backgroundColor = UIColor(hexString: Constants.Colors.CancelButton.Bitcoin)
            doneButton.enableColor = stringColor
            doneButton.isEnabled = true
        }
        
        let title = NSLocalizedString("Address for change in", comment: "") + " \(type.fullName())"
        titleLabel.text = title
        
        doneButton.setTitle(NSLocalizedString("Save", comment: ""), for: .normal)
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.changeAddresses.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 32.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let cell = cell as! ChangeAddressCell
        
        let address = itemAt(indexPath: indexPath)
        
        cell.nameLabel.text = address.name
        cell.addressLabel.text = address.pubAddress
        
        let stringColor = type == .emercoin ? Constants.Colors.Coins.Emercoin : Constants.Colors.Coins.Bitcoin
        
        let color = (selectedAddress == address.pubAddress) ? UIColor(hexString: stringColor) : UIColor.white
        cell.contentView.backgroundColor = color
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let address = itemAt(indexPath: indexPath)
        selectedAddress = address.pubAddress
        tableView.reload()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeAddressCell", for: indexPath)
        return cell
    }
    
    private func itemAt(indexPath:IndexPath) -> Address {
        return addresses.changeAddresses[indexPath.row]
    }
    
    override func doneButtonPressed(sender: UIButton?) {
        
        if let address = addresses.addressForChange(at: type) {
            if address.pubAddress != selectedAddress {
                if !selectedAddress.isEmpty {
                    if edit != nil {
                        edit!(selectedAddress)
                    }
                }
            }
        }
        
        super.doneButtonPressed(sender: sender)
    }

}
