//
//  AppManager.swift
//  EmercoinSecureWallet
//

import UIKit
import RealmSwift

class AppManager: NSObject {

    internal static let sharedInstance = AppManager()
    
    var isNeedShowPinProtection = false
    var isNeedLoadAllData = true
    
    var wallet:Wallet = Wallet()
    var alertsHelper = AlertsHelper()
    
    func logout() {
        
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        
        wallet = Wallet()
        
        Router.sharedInstance.tabBar = nil
        Router.sharedInstance.showInitialController()
    }
}
