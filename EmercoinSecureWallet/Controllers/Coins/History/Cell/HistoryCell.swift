//
//  HistoryCell.swift
//  EmercoinOne
//

import UIKit

class HistoryCell: BaseTableViewCell {

    let timeIconConfirmedHeight:CGFloat = 0
    let timeIconNoConfirmedHeight:CGFloat = 8
    
    @IBOutlet internal weak var dateLabeL:UILabel!
    @IBOutlet internal weak var addressLabeL:UILabel!
    @IBOutlet internal weak var amountLabeL:UILabel!
    @IBOutlet internal weak var directionImageView:UIImageView!
    @IBOutlet internal weak var timeImageView:UIImageView!
    @IBOutlet internal weak var timeWidthConstraint:NSLayoutConstraint!
    
    override func updateUI() {
        
        guard let viewModel = object as? HistoryTransactionViewModel else {
            return
        }
        
        dateLabeL.text = viewModel.date
        addressLabeL.text = viewModel.address
        let amount = viewModel.direction == .selfTx ? viewModel.fee : viewModel.amount
        amountLabeL.text = String(format:"%@ %@",amount,viewModel.sign)
        directionImageView.image = viewModel.imageTransactionDirection
        
        let isConfirmed = viewModel.isConfirmed
        timeImageView.isHidden = isConfirmed
        timeWidthConstraint.constant = isConfirmed ? timeIconConfirmedHeight : timeIconNoConfirmedHeight
    }
}
