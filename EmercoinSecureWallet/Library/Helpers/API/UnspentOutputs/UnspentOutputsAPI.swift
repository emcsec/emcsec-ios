//
//  UnspentInputsAPI.swift
//  EmercoinSecureWallet
//

import UIKit
import ObjectMapper

class UnspentOutputsAPI: BalancesAPI {

    override var method:String {
        return Constants.API.UnspentOutputs
    }
    
    override func apiDidReturnData(data: Any) -> Any? {
        
        if let data = data as? [[String:Any]] {
            let unspentOutputs = Mapper<UnspentOutput>().mapArray(JSONArray: data )
            return unspentOutputs.filter{$0.value > 0}
        }
        return nil
    }
}
