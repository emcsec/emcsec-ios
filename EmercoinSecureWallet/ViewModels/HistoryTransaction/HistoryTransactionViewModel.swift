//
//  HistoryTransactionViewModel.swift
//  EmercoinOne
//

import UIKit

class HistoryTransactionViewModel {
    
    var date:String = ""
    var dateFull:String = ""
    var address:String = ""
    var amount:String = ""
    var sign:String = "EMC"
    var category:String = ""
    var fee:String = ""
    var vout:String = ""
    var blockheight:String = ""
    var transactionId = ""
    var isConfirmed = true
    var imageTransactionDirection:UIImage? = nil
    var direction:TransactionDirection = .incoming
    
    init(historyTransaction:HistoryTransaction) {
        
        let type:CoinType = CoinType(name:historyTransaction.type)
        
        self.isConfirmed = historyTransaction.isConfirmed
        self.date = historyTransaction.date
        self.dateFull = historyTransaction.dateFull
        
        let unconfirmedText = NSLocalizedString("unconfirmed", comment: "")
        
        if !isConfirmed && type == .bitcoin {
            date = unconfirmedText
            dateFull = unconfirmedText
        }
        direction = historyTransaction.direction()
        self.address = direction == .selfTx ? NSLocalizedString("(n/a)", comment: "") : historyTransaction.address
        
        
        category = direction.title
        
        var fee = ""
        
        if direction == .incoming {
            fee = "None"
        } else {
            fee = String.coinFormat(at: historyTransaction.standartFee())
            fee.formattedNumber()
            fee = "-" + fee
        }
        
        var amount = String.coinFormat(at: historyTransaction.standartAmount())
        amount.formattedNumber()
        
        if direction == .outcoming {
            amount = "-" + amount
        }
        
        self.amount = amount
        
        self.fee = fee
        self.vout = String(historyTransaction.vout)
        
        let block = String(historyTransaction.blockheight)
        self.blockheight = historyTransaction.isConfirmed ? block : unconfirmedText
        
        self.transactionId = historyTransaction.txID
        
        self.sign = historyTransaction.type
        
        let image = direction == .selfTx ? "oper_ex_icon" : direction == .incoming ? "oper_rightarrow_icon" : "oper_leftarrow_icon"
        
        self.imageTransactionDirection = UIImage(named: image)
    }
}
