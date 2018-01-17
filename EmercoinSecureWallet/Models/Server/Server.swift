//
//  Server.swift
//  EmercoinSecureWallet
//

import UIKit
import RealmSwift

class Server: Object {
    
    @objc dynamic var port:Int32 = 0
    @objc dynamic var host = ""
    @objc dynamic var type = ""
    @objc dynamic var ssl = false
    
}
