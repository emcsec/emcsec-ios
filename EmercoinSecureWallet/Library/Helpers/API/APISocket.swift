//
//  API.swift
//  EmercoinSecureWallet
//

import UIKit
import Socket

class APISocket {
    
    var port:Int32 = 0
    var host = ""
    
    var success:(() -> (Void))?
    var failure:((_ error:NSError) -> (Void))?
    
    var type:CoinType = .bitcoin
    
    var isConnected:Bool {
        
        var result = false
        
        if let socket = socket {
            result = socket.isActive
        }
        return result
    }
    
    private var socket:Socket?

    func createSocket() {
        
        do {
            try socket = Socket.create()
            socket?.readBufferSize = 32768
            connect()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func connect() {
        
        do {
            try socket?.connect(to: host, port: port, timeout: 5000)
            try socket?.setReadTimeout(value: 20000)
            if success != nil {
                success!()
            }
        } catch let error {
            print("Failure connect, %@",error.localizedDescription)
            showServerError()
        }
    }
    
    func disconnect() {
        socket?.close()
    }
    
    func reconnect() {
        socket?.close()
        connect()
    }
    
    func send(at string:String) -> Any? {
        
        do {
            try socket?.write(from: string)
            //)
            var readData = Data(capacity: 1024*10)
            
            var object:Any? = nil
            
            
            repeat {
                
                let bytesRead = try socket?.read(into: &readData)
                if bytesRead! > 0 {
                    if let response = String(data: readData, encoding: .utf8) {
                        if let result = dictionaryFrom(string: response)?["result"] {
                            object = result
                            print(result)
                        } else if let error = dictionaryFrom(string: response)?["error"] as? [String:Any] {
                            if let message = error["message"] as? String {
                                failure!(NSError(domain: message, code: -1, userInfo: nil))
                                break
                            }
                        }
                    }
                } else {
                    showServerError()
                    break
                }
            } while object == nil
            return object
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func showServerError() {
        
        let text = String(format:"%@ %@",NSLocalizedString("Could not connect to the server for", comment: ""), type.fullName())
        failure?(NSError(domain: text, code: -1, userInfo: nil))
    }
    
    private func dictionaryFrom(string:String) -> [String:Any]? {
        var jsonObject:[String:Any] = [:]
        
        guard let data = string.data(using: String.Encoding.utf8) else {
            return nil
        }
        
        do {
            jsonObject = try JSONSerialization.jsonObject(with: data, options:[]) as![String:Any]
        } catch {
            return nil
        }
        
        return jsonObject
    }
}
