//
//  UnspentOutput.swift
//  EmercoinSecureWallet
//

import UIKit
import ObjectMapper
import RealmSwift

class UnspentOutput: Object, Mappable {

    @objc dynamic var value:Int64 = 0
    @objc dynamic var height:Int64 = 0
    @objc dynamic var index:Int = 0
    @objc dynamic var script:String = ""
    @objc dynamic var txHash = ""
    @objc dynamic var address = ""
    @objc dynamic var isInternal:Bool = false
    @objc dynamic var type:String = ""
    @objc dynamic var time:TimeInterval = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
        value <- map["value"]
        index <- map["tx_pos"]
        txHash  <- map["tx_hash"]
        height <- map["height"]
    }
}
