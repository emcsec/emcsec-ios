//
//  SpentOutput.swift
//  EmercoinSecureWallet
//

import RealmSwift
import UIKit

class SpentOutput: Object {

    @objc dynamic var value = 0
    @objc dynamic var height = 0
    @objc dynamic var index = 0
    @objc dynamic var txHash = ""
    @objc dynamic var time:TimeInterval = 0
    @objc dynamic var type = ""
    
}
