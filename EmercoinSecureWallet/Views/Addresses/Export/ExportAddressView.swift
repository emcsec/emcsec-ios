//
//  AddAddressView.swift
//  EmercoinOne
//

import UIKit

class ExportAddressView: EditAddressView {

    @IBOutlet internal weak var keyValueView:DetailValueView!
    @IBOutlet internal weak var qrCodeImageView:UIImageView!
    @IBOutlet internal weak var addressLabel:UILabel!
    @IBOutlet internal weak var keyLabel:UILabel!

    override func updateUI() {
        
        if coinType == .bitcoin {
            cancelButton.backgroundColor = UIColor(hexString: Constants.Colors.Coins.Bitcoin)
        }
        
        if let viewModel = viewModel {
            keyValueView.value = viewModel.key
            keyValueView.copyPressed = {[weak self] in
                self?.copyToBuffer(at: viewModel.key)
            }
            addressLabel.text = viewModel.address
            generateQRCode(at: viewModel.key)
        }
        
        var title = NSLocalizedString("Private key", comment: "")
        keyLabel.text = title
        cancelButton.setTitle(NSLocalizedString("Close", comment: ""), for: .normal)
    }
    
    private func generateQRCode(at text:String) {
        QRCodeHelper.generateQRCode(at: text, size: qrCodeImageView.frame.size, completion: { (image) in
            self.qrCodeImageView.image = image
        })
    }
    
    private func copyToBuffer(at text:String) {
        
        UIPasteboard.general.string = text
        showCopyView(at: self)
    }
}
