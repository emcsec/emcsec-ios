//
//  HistoryTransactionDetailView.swift
//  EmercoinOne
//

import UIKit

class HistoryTransactionDetailView: PopupView {

    @IBOutlet internal weak var dateValueView:DetailValueView!
    @IBOutlet internal weak var addressValueView:DetailValueView!
    @IBOutlet internal weak var categoryValueView:DetailValueView!
    @IBOutlet internal weak var amountValueView:DetailValueView!
    @IBOutlet internal weak var feeValueView:DetailValueView!
    @IBOutlet internal weak var transactionIdValueView:DetailValueView!
    @IBOutlet internal weak var blockheightValueView:DetailValueView!
    @IBOutlet internal weak var blockheightView:UIView!
    @IBOutlet internal weak var blockheightHeightConstraint:NSLayoutConstraint!
    @IBOutlet internal weak var blockheightTopConstraint:NSLayoutConstraint!
    @IBOutlet internal weak var feeHeightConstraint:NSLayoutConstraint!
    @IBOutlet internal weak var feeTopConstraint:NSLayoutConstraint!
    @IBOutlet weak var doneButton:YesButton!
    @IBOutlet weak var cancelButton:CancelButton!
    
    var repeatTransaction:(() -> (Void))?
    
    var viewModel:HistoryTransactionViewModel? {
        didSet {
            updateUI()
        }
    }
    
    var coinType:CoinType = .emercoin {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        
        if coinType == .bitcoin {
            cancelButton.backgroundColor = UIColor(hexString: Constants.Colors.CancelButton.Bitcoin)
            doneButton.backgroundColor = UIColor(hexString: Constants.Colors.Coins.Bitcoin)
        }
        
        doneButton.setTitle(NSLocalizedString("Repeat", comment: ""), for: .normal)
        cancelButton.setTitle(NSLocalizedString("Close", comment: ""), for: .normal)
        
        if let viewModel = viewModel {
        
            dateValueView.name = NSLocalizedString("Date", comment: "")
            addressValueView.name = NSLocalizedString("Address", comment: "")
            categoryValueView.name = NSLocalizedString("Category", comment: "")
            amountValueView.name = NSLocalizedString("Amount", comment: "")
            transactionIdValueView.name = NSLocalizedString("Transaction ID", comment: "")
            feeValueView.name = NSLocalizedString("Fee", comment: "")
            blockheightValueView.name = NSLocalizedString("Block", comment: "")
            
            let sign = viewModel.sign
            
            let fee = viewModel.fee
            
            let feeString = viewModel.direction == .incoming ? fee : fee +  " \(sign)"
            
            dateValueView.value = viewModel.dateFull
            amountValueView.value = viewModel.amount + " \(sign)"
            categoryValueView.value = viewModel.category
            feeValueView.value = feeString
            blockheightValueView.value = viewModel.blockheight
            
            let address = viewModel.address
            addressValueView.value = address
            addressValueView.copyPressed = {[weak self] in
                self?.copyToBuffer(at: address)
            }
            
            let transactionId = viewModel.transactionId
            transactionIdValueView.value = transactionId
            transactionIdValueView.copyPressed = {[weak self] in
                self?.copyToBuffer(at: transactionId)
            }
            
            if viewModel.direction == .incoming {
                feeTopConstraint.constant = 0
                feeHeightConstraint.constant = 0
            }
        }
    }
    
    private func copyToBuffer(at text:String) {
        
        UIPasteboard.general.string = text
        showCopyView()
    }
    
    @IBAction func repeatButtonPressed() {
        
        if repeatTransaction != nil {
            repeatTransaction!()
        }
        
        doneButtonPressed(sender: nil)
    }
}
