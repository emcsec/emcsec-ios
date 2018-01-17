//
//  Transaction.swift
//  EmercoinSecureWallet
//

import UIKit

class Transaction {
    
    var type:CoinType = .emercoin
    var raw:String  = "" {
        didSet {
            
            let networkType:WSNetworkType = type == .bitcoin ? WSNetworkTypeMain : WSNetworkTypeEmercoin
            let param = WSParametersForNetworkType(networkType)
            
            let buffer:WSBuffer = WSBufferFromHex(raw)
            do {
                let tx = try WSSignedTransaction(parameters: param, buffer: buffer, from: 0, available: buffer.length())
                
                self.timeInterval = TimeInterval(tx.time())
                if let outputs = tx.outputs().array as? [WSTransactionOutput] {
                    self.outputs.append(contentsOf: outputs)
                }
                if let inputs = tx.inputs().array as? [WSTransactionInput] {
                    self.inputs.append(contentsOf: inputs)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    var timeInterval:TimeInterval = 0
    var inputs:[WSTransactionInput] = []
    var outputs:[WSTransactionOutput] = []
    
    func outputsValue() -> UInt64 {
        var value:UInt64 = 0
        if !outputs.isEmpty {
            value = outputs.map{$0.value()}.reduce(0,+)
        }
        return value
    }
}
