//
//  Addresses.swift
//  EmercoinSecureWallet
//

import UIKit
import RealmSwift

class Addresses: NSObject {

    var type:CoinType = .bitcoin
    
    var addresses:Results<Address> {
        return allAddresses.filter("isUsingForChange == false")
    }
    
    var changeAddresses:Results<Address> {
        return allAddresses.filter("isUsingForChange == true")
    }
    
    var allAddresses:Results<Address> {
        
        let realm = try! Realm()
        return realm.objects(Address.self).filter("type==%@",type.fullName())
    }
    
    func add(addresses:[Address]) {
        
        removeAll()
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(addresses)
        }
    }
    
    func removeAll() {
        
        let realm = try! Realm()
        try! realm.write {
            realm.delete(addresses)
        }
    }
    
    func update(at name:String, index:Int) {
        let realm = try! Realm()
        try! realm.write {
            addresses[index].name = name
        }
    }
    
    func update(at balance:Int, address:Address) {
        let realm = try! Realm()
        try! realm.write {
            address.balance = balance
        }
    }
    
    func addressesArray() -> [String] {
        
        return addresses.map({!$0.name.isEmpty ? $0.name : $0.pubAddress})
    }
    
    func publicAdresses() -> [String] {
        return addresses.map({$0.pubAddress})
    }
    
    func addressForChange(at type:CoinType) -> Address? {
        self.type = type
        return changeAddresses.filter("isDefaultForChange == true").first
    }
    
    func containChangeAddress(at address:Address) -> Bool {
        
        let changes = Array(changeAddresses).map{$0.pubAddress}
        
        return changes.contains(address.pubAddress)
    }
    
    func changeAddressForChange(at address:String, type:CoinType) {
        
        if let currentChangeAddress = addressForChange(at: type) {
            if let newChangeAddress = changeAddresses.filter("pubAddress == %@",address).first {
                let realm = try! Realm()
                try! realm.write {
                    currentChangeAddress.isDefaultForChange = false
                    newChangeAddress.isDefaultForChange = true
                }
            }
        }
    }
}
