//
//  UserFee.swift
//  EmercoinSecureWallet
//

import UIKit
import RealmSwift

class UserFee: Object {

    @objc dynamic var recommended = 0.0
    @objc dynamic var custom = 0.0
}
