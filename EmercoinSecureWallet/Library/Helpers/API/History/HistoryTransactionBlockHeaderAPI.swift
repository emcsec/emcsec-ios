//
//  HistoryTransactionBlockHeaderAPI.swift
//  EmercoinSecureWallet
//

import UIKit

class HistoryTransactionBlockHeaderAPI: BaseAPI {

    override var timeOut:Int {
        return 100000
    }
    
    override var isNeedShowNetworkActivity:Bool {
        return false
    }
    
    override var method:String {
        return Constants.API.HistoryTransactionBlockHeader
    }
    
    override func parameters() -> [String : String] {
        
        var params = super.parameters()
        params["method"] = method
        
        if let height = object as? Int {
            params["params"] = String(format:"[\"%i\"]",height)
        }
        
        return params
    }
    
    override func apiDidReturnData(data: Any) -> Any? {
        
        if let result = data as? [String:Any] {
            
            if let timestamp = result["timestamp"] as? Double {
                return timestamp
            }
        } else {
            return data
        }
        return nil
    }
}
