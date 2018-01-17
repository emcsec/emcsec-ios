//
//  UnspentOutputs.swift
//  EmercoinSecureWallet
//

import UIKit
import RealmSwift

class UnspentOutputs {
    
    private let maxDaysToDeleteOutputs = 1

    var type:CoinType = .emercoin
    
    func outputs() -> Results<UnspentOutput> {
        let realm = try! Realm()
        return realm.objects(UnspentOutput.self).filter("type == %@",type.sign())
    }
    
    func addOutput(output:UnspentOutput) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(output)
        }
    }
    
    func removeOutput(output:UnspentOutput) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(output)
        }
    }
    
    func removeOutputs(outputs:[UnspentOutput]) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(outputs)
        }
    }
    
    func removeOldOutputs() {
        
        let date = Calendar.current.date(byAdding: .day, value: -maxDaysToDeleteOutputs, to: Date())
        let timeInterval = Int(date?.timeIntervalSince1970 ?? 0)
        let outputs = self.outputs().filter("time <= %i",timeInterval)
        
        if outputs.count > 0 {
            removeOutputs(outputs: Array(outputs))
        }
    }
    
    func removeOutputs(at txHash:String) {
        let outputs = self.outputs().filter("txHash == %@",txHash)
        
        if outputs.count > 0 {
            removeOutputs(outputs: Array(outputs))
        }
    }
    
    func containExternalOutput(output:UnspentOutput) -> Bool {
        
        let isContain = outputs().contains { (inOutput) -> Bool in
            return output.address == inOutput.address && output.txHash == inOutput.txHash && output.value == inOutput.value && output.index == inOutput.index
        }
        
        return isContain
    }
}
