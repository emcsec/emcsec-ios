//
//  SendViewModel.swift
//  EmercoinBasic
//

import UIKit
import RxSwift
import RxCocoa

class SendViewModel: CoinsOperationViewModel {
    
    var completion = PublishSubject<Bool>()
    var error = PublishSubject<NSError>()
    var walletLock = PublishSubject<Bool>()
    var walletCompletion = PublishSubject<Bool>()
    internal var isLoading = false

    func newTransaction(at transaction:Any) {
        
        if let tx = transaction as? [String:Any] {
            
            guard let amount = tx["amount"] as? Double, let address = tx["address"] as? String,
                let fee = tx["fee"] as? Double, let coinType = tx["type"] as? CoinType else {
                return
            }
            
            let inSatoshi = coinType == .emercoin ? satoshiInEmercoin : satoshiInBitcoin
            
            let spendCoins = SpendCoins()
            spendCoins.fee = UInt64(fee *  Double(inSatoshi))
            spendCoins.amount = UInt64(amount * Double(inSatoshi))
            spendCoins.type = coinType
            spendCoins.destinationAddress = address
            spendCoins.completion = { [weak self] state in
                self?.completion.onNext(state)
            }
            
            spendCoins.failure = { [weak self] errorData in
                self?.error.onNext(errorData)
            }
            spendCoins.createTransaction()
        }
    }
}
