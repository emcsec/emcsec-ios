//
//  Address.swift
//  EmercoinSecureWallet
//

import UIKit
import RealmSwift

class Address: Object {

    @objc dynamic var pubAddress:String = ""
    @objc dynamic var privKey:String = ""
    @objc dynamic var name:String = ""
    @objc dynamic var type:String = ""
    @objc dynamic var balance:Int = 0
    @objc dynamic var isUsingForChange:Bool = false
    @objc dynamic var isDefaultForChange:Bool = false
}
