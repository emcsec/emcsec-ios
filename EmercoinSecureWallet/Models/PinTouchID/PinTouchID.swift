//
//  PinTouchID.swift
//  EmercoinSecureWallet
//

import UIKit
import RealmSwift

class PinTouchID: Object {

    @objc dynamic var isEnabledPin = false
    @objc dynamic var isEnabledTouchID = false
    @objc dynamic var pin = ""
}
