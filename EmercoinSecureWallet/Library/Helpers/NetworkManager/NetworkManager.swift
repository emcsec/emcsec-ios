//
//  NetworkManager.swift
//  EmercoinSecureWallet
//
import UIKit

enum APIType {
    case balance
    case history
    case unspentOutputs
    case sendTransaction
}

struct ApiObject {
    var apiType:APIType = .balance
    var coinType:CoinType = .bitcoin
    var data:Any? = nil
    
    init(_ api:APIType, _ coin:CoinType, _ data:Any? = nil) {
        self.apiType = api
        self.coinType = coin
        self.data = data
    }
}

class NetworkManager {

    var apies:[ApiObject] = []
    var completion:((_ data:Any?) -> Void)?
    
    private var totalRequests = 0
    private var currentRequests = 0
    
    private var resultData:Any? = nil
    
    func sendTransaction(at raw:String,coin:CoinType) {
        
        let tx = ApiObject(.sendTransaction,coin,raw)
        apies.append(tx)
        executeApies()
    }
    
    func loadAllData() {
        
        let emBalance = ApiObject(.balance,.bitcoin)
        let btBalance = ApiObject(.balance,.emercoin)
        let emHistory = ApiObject(.history,.bitcoin)
        let btHistory = ApiObject(.history,.emercoin)
        
        apies.append(contentsOf: [emBalance,btBalance,emHistory,btHistory])
        executeApies()
    }
    
    func loadBalances() {
        
        let emBalance = ApiObject(.balance,.bitcoin)
        let btBalance = ApiObject(.balance,.emercoin)
        
        apies.append(contentsOf: [emBalance,btBalance])
        executeApies()
    }
    
    func loadBalance(at type:CoinType) {
        let balance = ApiObject(.balance,.emercoin)
        apies.append(contentsOf: [balance])
        executeApies()
    }
    
    func loadHistory(at type:CoinType) {
        let history = ApiObject(.history,type)
        let balance = ApiObject(.balance,type)
        apies.append(contentsOf: [history,balance])
        executeApies()
    }
    
    func loadHistory() {
        
        let emHistory = ApiObject(.history,.bitcoin)
        let btHistory = ApiObject(.history,.emercoin)
        
        apies.append(contentsOf: [emHistory,btHistory])
    }
    
    func loadUnspentOutputs(at type:CoinType, completion:@escaping (_ data: Any?) -> Void) {
        
        self.completion = completion
        
        let outputs = ApiObject(.unspentOutputs, type)
        apies.append(contentsOf: [outputs])
        executeApies()
    }
    
    func executeApies() {
        
        showInternetActivity(at: true)
        showProgressView(state: true)
        
        self.updateProgress()
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let downloadGroup = DispatchGroup()
            
            for api in self.apies {
                
                let apiManager = APIManager()
                apiManager.apiType = api.apiType
                apiManager.coinType = api.coinType
                apiManager.socket = APISocketsManager.sharedInstance.socket(at: api.coinType)
                apiManager.data = api.data
                apiManager.progress = {current, total in
                    self.totalRequests += total
                    self.currentRequests += current
                    self.updateProgress()
                }
                
                downloadGroup.enter()
                apiManager.load(completion: {[weak self] data, error in
                    
                    apiManager.clearSocket()
                    
                    if error != nil {
                        DispatchQueue.main.async {
                            showErroViewAlert(error: error!)
                        }
                        
                        downloadGroup.leave()
                        return
                    }
                    
                    if data != nil {
                        self?.resultData = data
                        
                        self?.processindApiData(at: data, apiObject: api, completion: {
                            downloadGroup.leave()
                        })
                    } else {
                        downloadGroup.leave()
                    }
                })
            }
            
            _ = downloadGroup.wait(timeout: .now() + 15)
            DispatchQueue.main.async {
                self.apies.removeAll()
                showInternetActivity(at: false)
                showProgressView(state: false)
                self.completion?(self.resultData)
            }
        }
    }
    
    private func updateProgress() {
        let dict = ["current":self.currentRequests,"total":self.totalRequests]
        updateProgressView(at: dict)
    }
    
    func processindApiData(at data:Any?, apiObject:ApiObject, completion:()->Void) {
        
        switch apiObject.apiType {
        case .history:
            let history = History()
            history.type = apiObject.coinType
            if let txList = data as? [HistoryTransaction] {
                if txList.count > 0 {
                    history.processingAndAdd(at: txList)
                }
            }
        default:
            break
        }
        completion()
    }
}
