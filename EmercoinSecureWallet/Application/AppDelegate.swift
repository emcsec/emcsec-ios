//
//  AppDelegate.swift
//  EmercoinSecureWallet
//

import UIKit
import RealmSwift
import IQKeyboardManagerSwift
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.shared.statusBarStyle = .lightContent
        
        setupRealm()
        IQKeyboardManager.sharedManager().enable = true
        DropDown.startListeningToKeyboard()
    
        window = UIWindow(frame:UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        if let window = self.window {
            window.rootViewController = Router.sharedInstance.initialController()
        }
        
        AppManager.sharedInstance.isNeedShowPinProtection = true
        
        return true
    }
    
    private func setupRealm() {
        
        guard let version:UInt64 = UInt64(buildVersion()) else {
            return
        }
        
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: version,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < version) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        let realm = try! Realm()
        print(realm)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("applicationDidEnterBackground")
        AppManager.sharedInstance.isNeedShowPinProtection = true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("applicationDidBecomeActive")
        
        let appManager = AppManager.sharedInstance
        
        if appManager.isNeedShowPinProtection && !appManager.isNeedLoadAllData {
            if let tabBar = Router.sharedInstance.tabBar {
                tabBar.showPinView()
            }
        }
    }
}

