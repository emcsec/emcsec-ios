//
//  BalancesAPI.swift
//  EmercoinSecureWallet
//

import UIKit

class BalancesAPI: BaseAPI {

    override var isNeedShowNetworkActivity:Bool {
        return false
    }
    
    override var method:String {
        return Constants.API.Balances
    }
    
    override func parameters() -> [String : String] {
        
        var params = super.parameters()
        params["method"] = method
        
        if let address = object as? String {
            params["params"] = String(format:"[\"%@\"]",address)
        }
        
        return params
    }
    
    override func apiDidReturnData(data: Any) -> Any? {
        
        //var balance = 0
        
        if let address = object as? String {
            print(address)
        }
        if let result = data as? [String:Any] {
            
//            if let confirmed = result["confirmed"] as? Int {
//                balance += confirmed
//            }
//
//            if let unconfirmed = result["unconfirmed"] as? Int {
//                if unconfirmed < 0 || {
//                    balance += unconfirmed
//                }
//            }
//            return balance
            return result
        }
        
        return nil
    }
}
