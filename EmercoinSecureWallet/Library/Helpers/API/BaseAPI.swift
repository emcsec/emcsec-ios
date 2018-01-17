//
//  BaseAPI.swift
//  EmercoinBasic
//

import UIKit

class BaseAPI: NSObject {
    
    var timeOut:Int {
        return 0
    }
    
    var completion:((_ data:Any?) -> Void)?
    var done:(() -> Void)?
    
    var type:CoinType = .bitcoin // default
    
    var socket:APISocket?
    
    var isNeedShowNetworkActivity:Bool {
        return true
    }
    
    var method:String {
        return ""
    }
    
    var object:Any?

    public func loadData() -> Any? {
        
        let message = self.message()
    
        if let socket = socket {
//            if timeOut != 0 {
//                usleep(useconds_t(timeOut))
//            }
            if let result = socket.send(at: message) {
                return self.apiDidReturnData(data: result)
            }
        }
        return nil
    }
    
    func apiDidReturnData(data:Any) -> Any? {
        return data
    }
    
    func parameters() -> [String:String] {
        
        var parameters:[String:String] = [:]
        parameters["jsonrpc"] = "2.0"
        parameters["id"] = "null"
        
        return parameters
    }
    
    private func message() -> String {
        
        let param = parameters()
        
        var message = "{"
        
        for (key,value) in param {
            
            if key == "params" {
                message = message + String(format:"\"%@\":%@,",key,value)
            } else {
                message = message + String(format:"\"%@\":\"%@\",",key,value)
            }
        }
        message = message.removeLast()
        message.append("}\n")
        
        return message
    }
}
