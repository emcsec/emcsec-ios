//
//  APISocketsManager.swift
//  EmercoinSecureWallet
//

import Foundation
import UIKit

final class APISocketsManager {
    
    internal static let sharedInstance = APISocketsManager()
    
    var bitcoinSocket:APISocket = APISocket()
    var emercoinSocket:APISocket = APISocket()
    
    func initSockets() {
        
        guard let emercoinServer = Settings.server(at: .emercoin), let bitcoinServer = Settings.server(at: .bitcoin)  else {
            return
        }
        
        bitcoinSocket.host = bitcoinServer.host
        bitcoinSocket.port = bitcoinServer.port
        emercoinSocket.host = emercoinServer.host
        emercoinSocket.port = emercoinServer.port
        emercoinSocket.type = .emercoin
    }
    
    func connectSockets(completion:@escaping (_ error:NSError?) -> Void) {
        
        bitcoinSocket.disconnect()
        emercoinSocket.disconnect()
        
        bitcoinSocket.failure = completion
        emercoinSocket.failure = completion
        
        bitcoinSocket.createSocket()
        emercoinSocket.createSocket()
    }
    
    func socket(at type:CoinType) -> APISocket {
        return type == .bitcoin ? bitcoinSocket : emercoinSocket
    }
}
