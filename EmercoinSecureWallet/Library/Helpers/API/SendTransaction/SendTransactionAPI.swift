//
//  SendTransactionAPI.swift
//  EmercoinSecureWallet
//

import UIKit

class SendTransactionAPI: BalancesAPI {

    override var method:String {
        return Constants.API.SendTransaction
    }
    
    override func apiDidReturnData(data: Any) -> Any? {
        
        if let result = data as? String {
            return result
        }
        return nil
    }
}
