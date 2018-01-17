//
//  HistoryTransaction.swift
//  EmercoinOne
//

import UIKit
import ObjectMapper
import RealmSwift

enum  TransactionDirection:Int {
    case incoming = 0
    case outcoming = 1
    case selfTx = 2
    
    var title:String {
        var string = ""
        switch self {
            case .incoming:string = NSLocalizedString("receiveTx", comment: "")
            case .outcoming:string = NSLocalizedString("sendTx", comment: "")
            case .selfTx:string = NSLocalizedString("Self", comment: "")
        }
        return string
    }
}

class HistoryTransaction:Object, Mappable {
    
    @objc dynamic var amount:Int = 0
    @objc dynamic var fee:Int = 0
    @objc dynamic var vout:Int = 0
    @objc dynamic var outputsAmount:Int = 0
    @objc dynamic var date = ""
    @objc dynamic var dateFull = ""
    @objc dynamic var blockheight = 0 {
        didSet {
            isConfirmed = blockheight > 0
        }
    }
    @objc dynamic var blockhash = ""
    @objc dynamic var txID = ""
    @objc dynamic var lockTime:Int = 0
    @objc dynamic var txRaw = "" {
        didSet {
            let tx = self.transaction()
            self.timeInterval = tx.timeInterval
            if tx.outputs.count > 0  {
                self.recognizeSelfTx(at: tx)
                if !(self.direction() == .selfTx) {
                    self.processingOutputs(at: tx)
                }
            }
        }
    }
    
    @objc dynamic var isConfirmed = true
    @objc dynamic var type = ""
    @objc dynamic var timeInterval:TimeInterval = 0 {
        didSet {
            let interval = timeInterval.timeIntervalFormat()
            let date = Date(timeIntervalSince1970: interval)
            self.date = date.transactionStringDate()
            self.dateFull = date.transactionStringDateFull()
        }
    }
    @objc dynamic var address = ""
    @objc dynamic var category = 0
    
    func recognizeSelfTx(at tx:Transaction) {
        
        let unspentOutpunts = UnspentOutputs()
        
        let outputs = tx.outputs
        let inputs = tx.inputs
        
        var txHashs:[String] = []
        
        let addresses = Addresses()
        addresses.type = CoinType(name: type)
        
        var isInputsMy = false
        var isOutputsMy = false
        
        inputs.forEach { (input) in
            
            txHashs.append(input.outpoint().txId().description)
            
            if (addresses.allAddresses.map{$0.pubAddress}.contains(input.address().description)) {
                isInputsMy = true
            }
        }
        
        outputs.forEach { (output) in
            if (addresses.addresses.map{$0.pubAddress}.contains(output.address().description)) {
                isOutputsMy = true
                self.amount = Int(output.value())
            }
        }
        
        if isInputsMy && isOutputsMy {
            self.category = TransactionDirection.selfTx.rawValue
        }
        
        for hash in txHashs {
            unspentOutpunts.removeOutputs(at: hash)
        }
    }
    
    func processingOutputs(at tx:Transaction) {
        
        let outputs = tx.outputs
        
        let addresses = Addresses()
        addresses.type = CoinType(name: type)
        
        var amount:UInt64 = 0
        
        var isIncomingTx = false
        var changeAddress = ""
        
        outputs.forEach({ (output) in
            let outAddress = output.address().description
            if ( addresses.addresses.map{$0.pubAddress}.contains(outAddress)) {
                isIncomingTx = true
                if outAddress == self.address {
                    amount = output.value()
                }
            } else if ( addresses.changeAddresses.map{$0.pubAddress}.contains(outAddress))  {
                changeAddress = outAddress
            }
        })
        
        if !isIncomingTx {
            outputs.forEach({ (output) in
                let outAddress = output.address().description
                if outAddress != changeAddress {
                    amount=output.value()
                    self.address = outAddress
                }
            })
        }
        
        self.amount = Int(amount)
        self.category = isIncomingTx ? TransactionDirection.incoming.rawValue : TransactionDirection.outcoming.rawValue
    }
    
    func direction() -> TransactionDirection {
        return TransactionDirection(rawValue: category)!
    }
    
    func transaction() -> Transaction {
        let tx = Transaction()
        tx.type = CoinType(name: type)
        tx.raw = txRaw
        return tx
    }
    
    func standartAmount() -> Double {
        let inSatoshi = type == "EMC" ? satoshiInEmercoin : satoshiInBitcoin
        return Double(amount) / Double(inSatoshi)
    }
    
    func standartFee() -> Double {
        let inSatoshi = type == "EMC" ? satoshiInEmercoin : satoshiInBitcoin
        return Double(fee) / Double(inSatoshi)
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        amount <- map["value"]
        address <- map["address"]
        category <- map["category"]
        blockheight <- map["height"]
        blockhash <- map["blockhash"]
        txID <- map["tx_hash"]
        fee <- map["fee"]
        vout <- map["vout"]
    }
}
