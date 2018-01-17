//
//  HistoryTransactionBlockAPI.swift
//  EmercoinSecureWallet
//

import UIKit

class HistoryTransactionRawAPI: BaseAPI {

    override var timeOut:Int {
        return 100000
    }
    
    override var isNeedShowNetworkActivity:Bool {
        return false
    }
    
    override var method:String {
        return Constants.API.HistoryTransactionRaw
    }
    
    override func parameters() -> [String : String] {
        
        var params = super.parameters()
        params["method"] = method
        
        if let txHash = object as? String {
            params["params"] = String(format:"[\"%@\"]",txHash)
        }
        
        return params
    }
    
    override func apiDidReturnData(data: Any) -> Any? {
        
        if let txRaw = data as? String {
            return txRaw
        }
        return nil
    }
}
