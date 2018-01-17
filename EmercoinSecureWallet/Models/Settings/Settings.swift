
//
//  Settings.swift
//  EmercoinSecureWallet
//

import UIKit
import RealmSwift

class Settings: NSObject {
    
    static var pinTouchID:PinTouchID? {
        let realm = try! Realm()
        return realm.objects(PinTouchID.self).first
    }

    static var userFee:UserFee? {
        let realm = try! Realm()
        return realm.objects(UserFee.self).first
    }

    static func server(at type:CoinType) -> Server? {
        let realm = try! Realm()
        return realm.objects(Server.self).filter("type == %@",type.fullName()).first
    }
    
    static func updateServer(host:String, port:Int32, ssl:Bool, type:CoinType) {
        if let server = self.server(at:type) {
            let realm = try! Realm()
            try! realm.write {
                server.host = host
                server.port = port
                server.ssl = ssl
            }
        }
    }
    
    static func addUserFee(at object:UserFee) {
        
        let realm = try! Realm()
        try! realm.write {
            if let userFee = userFee {
                realm.delete(userFee)
            }
            realm.add(object)
        }
    }
    
    static func addPinTouchID(at object:PinTouchID) {
        
        clear()
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(object)
        }
    }
    
    static func clear() {
        
        let realm = try! Realm()
        try! realm.write {
            realm.delete(realm.objects(PinTouchID.self))
        }
    }
    
    static func baseInitServerSettings() {
        
        let bitType = CoinType.bitcoin
        let emerType = CoinType.emercoin
        
        guard let _ = server(at: emerType), let _ = server(at: bitType) else {
         
            let emercoinServer = Server()
            emercoinServer.host = "emcx.emercoin.com"
            emercoinServer.port = 9110
            emercoinServer.type = emerType.fullName()
            
            let bitcoinserver = Server()
            bitcoinserver.host = "btcx.emercoin.com"
            bitcoinserver.port = 50001
            bitcoinserver.type = bitType.fullName()
            
            let realm = try! Realm()
            try! realm.write {
                realm.add([emercoinServer,bitcoinserver])
            }
            return
        }
    }
    
    static func baseInitUserFee() {
        
        guard let _ = userFee else {
            let fee = UserFee()
            fee.recommended = 0.00148372
            fee.custom = fee.recommended
            
            addUserFee(at: fee)
            return
        }
    }
    
    static func baseInit() {
        baseInitServerSettings()
        baseInitUserFee()
    }
}
