//
//  HistoryTransactionsAPI.swift
//  EmercoinSecureWallet
//
import UIKit
import ObjectMapper

class HistoryTransactionsAPI: BalancesAPI {

    override var timeOut: Int {
        return 100000
    }
    
    override var method:String {
        return Constants.API.HistoryTransactions
    }
    
    override func apiDidReturnData(data: Any) -> Any? {
        
        if let data = data as? [[String:Any]] {
            let historyTransactions = Mapper<HistoryTransaction>().mapArray(JSONArray: data )
            return historyTransactions
        }
        
        return nil
    }
}
