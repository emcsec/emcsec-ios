//
//  SpendCoins.swift
//  EmercoinSecureWallet
//

import UIKit

class SpendCoins {
    
    var amount:UInt64 = 10000
    var fee:UInt64 = 100 {
        didSet {
            totalFee = fee
        }
    }
    var totalFee:UInt64 = 100
    var type:CoinType = .emercoin
    var destinationAddress = ""
    private var txId = ""
    private var error:NSError?
    
    var completion:((_ state:Bool) -> Void)?
    var failure:((_ error:NSError) -> Void)?
    
    private var utxosCount = 0
    private var usedUtxos:[UnspentOutput] = []
    private var isCanSendTx = false
    private let spentOutputs = SpentOutputs()
    private let unspentOutputs = UnspentOutputs()
    private var unspentOutput:UnspentOutput? = nil
    private let networkManager = NetworkManager()
    
    func createTransaction() {
        
        unspentOutputs.type = type
        spentOutputs.type = type
        
        loadUnspentOutputs { (utxos) in
            if let utxos = utxos as? [UnspentOutput] {
                if let txRaw = self.createTx(utxos: utxos) {
                    if self.type == .emercoin {
                        self.sendTransaction(at: txRaw)
                    } else {
                        self.utxosCount = 0
                        repeat {
                            if let tx = self.createTx(utxos: utxos) {
                                if self.isCanSendTx {
                                    self.sendTransaction(at: tx)
                                } else {
                                    let size = tx.size()
                                    self.totalFee = UInt64(size) * self.fee
                                }
                            } else {
                                self.returnError()
                                break
                            }
                        } while !self.isCanSendTx
                    }
                } else {
                    if self.completion != nil {
                        self.completion!(false)
                    }
                    self.returnError()
                }
            }
        }
    }
    
    private func returnError() {
        
        if self.failure != nil && self.error != nil {
            self.failure!(self.error!)
        }
    }
    
    private func sendTransaction(at tx:WSSignedTransaction) {
        
        let txRaw = tx.toBuffer().hexString() ?? ""
        
        let api = self.networkManager
        api.completion = { data in
            var success = false
            
            if let result = data as? String {
                success = self.txId == result
                
                if success {
                    if self.completion != nil {
                        self.completion!(success)
                        self.processingUTXOs()
                    }
                } else {
                    
                    let text = "the transaction was rejected by network rules"
                    
                    var message = result
                    
                    if result.lowercased().contains(text) {
                        message = NSLocalizedString("The transaction was rejected by network rules", comment: "")
                    }
                    
                    self.error = NSError(domain: message, code: -1, userInfo: nil)
                    self.returnError()
                }
            }
        }
        api.sendTransaction(at: txRaw, coin: self.type)
    }
    
    private func processingUTXOs() {
        
        var outputs:[SpentOutput] = []
        
        var removedOutputs:[UnspentOutput] = []
        
        for utxo in usedUtxos {
            
            let spentOutput = SpentOutput()
            spentOutput.height = Int(utxo.height)
            spentOutput.index = utxo.index
            spentOutput.txHash = utxo.txHash
            spentOutput.value = Int(utxo.value)
            spentOutput.time = Date().timeIntervalSince1970
            spentOutput.type = self.type.sign()
            
            outputs.append(spentOutput)
            
            if utxo.isInternal {
                removedOutputs.append(utxo)
            }
        }
        
        if !outputs.isEmpty {
            spentOutputs.addOutputs(outputs: outputs)
        }
        spentOutputs.removeOldOutputs()
        unspentOutputs.removeOldOutputs()
        
        if let output = unspentOutput {
            output.txHash = self.txId
            unspentOutputs.addOutput(output: output)
        }
        
        if !removedOutputs.isEmpty {
            unspentOutputs.removeOutputs(outputs: removedOutputs)
        }
    }
    
    private func loadUnspentOutputs(completion:@escaping (_ data: Any) -> Void) {
        self.networkManager.loadUnspentOutputs(at: type,completion: completion)
    }
    
    private func createTx(utxos:[UnspentOutput]) -> WSSignedTransaction? {
        
        let totalAmount = amount + totalFee;
        
        var utxos = utxos.filter{!unspentOutputs.containExternalOutput(output: $0)}
        utxos = utxos.filter{!(spentOutputs.containOutput(output: $0))}
        utxos = type == .emercoin ? utxos.sorted{$0.height > $1.height} : utxos.sorted{$0.value > $1.value}
        
        utxos = Array(unspentOutputs.outputs()) + utxos
        
        var txouts:[UnspentOutput] = []
        self.usedUtxos.removeAll()
        self.unspentOutput = nil
        
        for utxo in utxos {
            txouts.append(utxo)
            
            let sum = txouts.map{$0.value}.reduce(0, +)
            
            if sum > totalAmount {
                break;
            }
        }
        
        if utxosCount != 0 {
            isCanSendTx = txouts.count == utxosCount
        }
        
        utxosCount = txouts.count
        usedUtxos.append(contentsOf: txouts)
        
        let sum = txouts.map{$0.value}.reduce(0, +)
        if sum < totalAmount {
            let errorText = NSLocalizedString("Insufficient funds", comment: "")
            self.error = NSError(domain: errorText, code: -1, userInfo: nil)
            return nil
        }
        
        let txbuilder = WSTransactionBuilder()
        var spentCoins:UInt64 = 0;
        var inputKeys:[AnyHashable:Any] = [:]
        let networkType:WSNetworkType = type == .bitcoin ? WSNetworkTypeMain : WSNetworkTypeEmercoin
        let param = WSParametersForNetworkType(networkType)
        let addresses = Addresses()
        addresses.type = type
        
        for txout in txouts {
            
            guard let address = addresses.allAddresses.filter("pubAddress == %@",txout.address).first  else {
                return nil
            }
            
            guard let utxoAddress = WSAddress(parameters: param, encoded: txout.address)  else {
                return nil
            }
            
            let key:WSKey = WSKey(wif: address.privKey, parameters: param)
            let previousOutputScript = WSScript(address: key.address(with: param))
            let previousOutput = WSTransactionOutput(parameters: param, script: previousOutputScript, value: UInt64(txout.value))
            let inputTxId = WSHash256FromHex(txout.txHash)
            let inputOutpoint =  WSTransactionOutPoint.outpoint(with: param, txId: inputTxId, index: UInt32(txout.index))
            let input = WSSignableTransactionInput(previousOutput: previousOutput, outpoint: inputOutpoint)
            
            assert(utxoAddress == input?.address(), "Input address differs")
            
            inputKeys[utxoAddress] = key
            txbuilder?.addSignableInput(input)
            
            let value:UInt64 = UInt64(txout.value)
            spentCoins += value
        }
        
        guard let change = addresses.addressForChange(at: type) else {
            return nil
        }
        
        let destAddress = WSAddress(parameters: param, encoded: destinationAddress)
        let changeAddress = WSAddress(parameters: param, encoded: change.pubAddress)
        let changeAmount = spentCoins - totalAmount
        let paymentOutput =  WSTransactionOutput(address: destAddress, value: amount)
        let changeOutput =  WSTransactionOutput(address: changeAddress, value: changeAmount)
        
        
        let minFee = type == .emercoin ? totalFee * 100 : 546
        
        txbuilder?.addOutput(paymentOutput)
        if changeAmount >= minFee {
            txbuilder?.addOutput(changeOutput)
            
            let output = UnspentOutput()
            output.address = change.pubAddress
            output.value = Int64(changeAmount)
            output.isInternal = true
            output.type = self.type.sign()
            output.time = Date().timeIntervalSince1970
            if let index = txbuilder?.outputs().index(of: changeOutput as Any) {
                output.index = index
            }
            
            self.unspentOutput = output
        }
        
        var error:NSError? = nil
        let tx = txbuilder?.signedTransaction(withInputKeys: inputKeys, error: &error, param:param)
        txId = tx?.txId().description ?? ""
        return tx
    }
}

