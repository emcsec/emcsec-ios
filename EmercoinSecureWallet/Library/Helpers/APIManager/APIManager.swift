//
//  APIManager.swift
//  EmercoinSecureWallet
//

import UIKit

class APIManager: NSObject {
    
    var coinType:CoinType = .bitcoin
    var apiType:APIType = .balance
    var socket:APISocket?
    var data:Any?
    var progress:((_ currentValue:Int, _ totalValue:Int) -> (Void))?
    
    func clearSocket() {
        socket?.failure = nil
        socket?.success = nil
        socket = nil
    }
    
    func load(completion:@escaping (_ data: Any?, _ error:NSError?) -> Void) {
        
        let type = apiType
        
        if let socket = socket {
            
            socket.failure = {[weak self] error in
                completion(nil,error)
            }
            
            socket.success = {[weak self] in
                    switch type {
                        case .balance, .unspentOutputs:
                            self?.loadData(completion: completion)
                        case .sendTransaction:
                            self?.sendTransaction(completion: completion)
                        case .history:
                            self?.loadTransactions(completion: completion)
                    }
            }
            socket.createSocket()
        }
    }
    
    func sendTransaction(completion:@escaping (_ data: Any?, _ error:NSError?) -> Void) {
        
        let api = getApi(at: .sendTransaction)
        api.type = self.coinType
        api.socket = self.socket
        api.object = data
        
        if let data = api.loadData() {
            sleep(3)
            completion(data, nil)
        } else {
            return
        }
    }
    
    func loadBalance(completion:@escaping (_ data: Any?, _ error:NSError?) -> Void) {
        
            //let downloadGroup = DispatchGroup()
            
        let addresses = Addresses()
        addresses.type = self.coinType
        
        for address in addresses.addresses {
            let api = BalancesAPI()
            api.object = address.pubAddress
            api.type = self.coinType
            api.socket = self.socket
            
            if let balance = api.loadData() as? Int {
                addresses.update(at: balance, address: address)
            }
        }
        completion(addresses.addresses, nil)
    }
    
    private func loadData(completion:@escaping (_ data: Any?, _ error:NSError?) -> Void) {
    
        let addresses = Addresses()
        addresses.type = self.coinType
        
        let api = getApi(at: apiType)
        api.socket = self.socket
        api.type = self.coinType
        
        var utxosData:[UnspentOutput] = []
        
        progress?(0,addresses.allAddresses.count)
        
        for address in addresses.allAddresses {
            
            api.object = address.pubAddress
            
            if let data = api.loadData() {
                
                progress?(1,0)
                
                switch self.apiType {
                    case .balance:
                        if let balance = data as? [String:Any] {
                            print(balance)
                            
                            var value = 0
                            
                            if let confirmed = balance["confirmed"] as? Int {
                                value += confirmed
                            }
                
                            if let unconfirmed = balance["unconfirmed"] as? Int {
                                if (unconfirmed < 0) || (addresses.containChangeAddress(at: address)) {
                                    value += unconfirmed
                                }
                            }
                            
                            addresses.update(at: value, address: address)
                        } else {
                            return
                        }
                case .unspentOutputs:
                    if let utxos = data as? [UnspentOutput] {
                        
                        utxos.forEach({ (utxo) in
                            utxo.address = address.pubAddress
                        })
                        
                        if utxos.count > 0 {
                            utxosData.append(contentsOf: utxos)
                        }
                    } else {
                        return
                    }
                    default:break
                }
            } else {
                return
            }
        }
        
        let dataValue = apiType == .unspentOutputs ? utxosData : nil
        
        completion(dataValue, nil)
    }
    
    private func getApi(at type:APIType) -> BaseAPI {
        
        var api = BaseAPI()
        
        switch type {
            case .balance:
                api = BalancesAPI()
            case .history:
                api = HistoryTransactionsAPI()
            case .unspentOutputs:
                api = UnspentOutputsAPI()
            case .sendTransaction:
                api = SendTransactionAPI()
        }
        
        return api
    }
    
    func loadTransactions(completion:@escaping (_ data: Any?, _ error:NSError?) -> Void) {
        
        let addresses = Addresses()
        addresses.type = coinType
        
        var historyTransactions:[HistoryTransaction] = []
        
        let api = HistoryTransactionsAPI()
        api.type = coinType
        api.socket = socket
        
        let rawAPI = HistoryTransactionRawAPI()
        rawAPI.socket = socket
        rawAPI.type = coinType
        
        let blockAPI = HistoryTransactionBlockHeaderAPI()
        blockAPI.type = coinType
        blockAPI.socket = socket
        
        progress?(0,addresses.allAddresses.count)
        
        for address in addresses.allAddresses {
            
            api.object = address.pubAddress
            
            if let historyTrs = api.loadData() as? [HistoryTransaction] {
                progress?(1,historyTrs.count)
                
                for tx in historyTrs {
                    
                    var isExistingHash = false//historyTransactions.map{$0.txID}.contains(tx.txID)
                    
                    let existTxs = historyTransactions.filter{$0.txID == tx.txID}
                    //isExistingHash = existTxs.count > 0
                    
                    for exTx in existTxs {
                        if exTx.direction() != .incoming {
                            isExistingHash = true
                            break
                        }
                    }
                    
                    if  !isExistingHash {
                        tx.address = address.pubAddress
                        tx.type = addresses.type.sign()
                        
                        rawAPI.object = tx.txID
                        if let txRaw = rawAPI.loadData() as? String {
                            tx.txRaw = txRaw
                            if tx.isNVS {
                                break
                            }
                        } else {
                            return
                        }
                        
                        if tx.direction() == .outcoming || tx.direction() == .selfTx {
                            
                            var inputsAmount:UInt64 = 0
                            
                            for input in tx.transaction().inputs {
                                rawAPI.object = input.outpoint().txId().description
                                if let txRaw = rawAPI.loadData() as? String {
                                    let prevTx = Transaction()
                                    prevTx.type = CoinType(name: tx.type)
                                    prevTx.raw = txRaw
                                    
                                    let prevIndex = input.outpoint().index()
                                    
                                    if prevIndex < prevTx.outputs.count {
                                        let txout = prevTx.outputs[Int(prevIndex)]
                                        inputsAmount += UInt64(txout.value())
                                    }
                                } else {
                                    return
                                }
                            }
                            
                            let outputsAmount = tx.transaction().outputsValue() 
                            
                            if outputsAmount <= inputsAmount {
                                tx.fee = Int(inputsAmount - outputsAmount)
                            }
                        }
                        
                        if coinType == .bitcoin {
                            
                            blockAPI.object = tx.blockheight
                            if let timestamp = blockAPI.loadData() as? Double {
                                tx.timeInterval = timestamp
                                historyTransactions.append(tx)
                            } else {
                                return
                            }
                        } else {
                            historyTransactions.append(tx)
                        }
                    }
                    progress?(1,0)
                }
            } else {
                return
            }
        }
        completion(historyTransactions, nil)
    }
    
    func loadCoinExchangeRates(at currency:CurrencyType,coin:CoinType,completion:@escaping (_ price: Double) -> Void) {
        
        let api = CoinCourseAPI()
        api.coin = coin
        api.currency = currency
        api.startRequest(completion: completion)
    }
}
