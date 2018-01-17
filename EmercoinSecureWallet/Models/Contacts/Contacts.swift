//
//  Contacts.swift
//  EmercoinSecureWallet
//

import UIKit
import RealmSwift

class Contacts: NSObject {

    var type:CoinType = .bitcoin
    
    var contacts:Results<Contact> {
        
        let realm = try! Realm()
        return realm.objects(Contact.self).filter("type==%@",type.fullName())
    }
    
    func add(contact:Contact) {
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(contact)
        }
    }
    
    func add(contacts:[Contact]) {
        
        removeAll()
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(contacts)
        }
    }
    
    func removeAll() {
        
        let realm = try! Realm()
        try! realm.write {
            realm.delete(contacts)
        }
    }
    
    func remove(at contact:Contact) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(contact)
        }
    }
    
    func update(at name:String, index:Int) {
        let realm = try! Realm()
        try! realm.write {
            contacts[index].name = name
        }
    }
    
    func update(at name:String, address:String,  index:Int) {
        let realm = try! Realm()
        try! realm.write {
            contacts[index].name = name
            contacts[index].address = address
        }
    }
}
