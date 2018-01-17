//
//  SpentOutputs.swift
//  EmercoinSecureWallet
//

import UIKit
import RealmSwift

class SpentOutputs {

    private let maxDaysToDeleteOutputs = 7
    
    var type:CoinType = .emercoin
    
    func outputs() -> Results<SpentOutput> {
        let realm = try! Realm()
        return realm.objects(SpentOutput.self).filter("type == %@",type.sign())
    }
    
    func addOutput(output:SpentOutput) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(output)
        }
    }
    
    func addOutputs(outputs:[SpentOutput]) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(outputs)
        }
    }
    
    func removeOutput(output:SpentOutput) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(output)
        }
    }
    
    func removeOutputs(outputs:[SpentOutput]) {
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
    
    func containOutput(output:UnspentOutput) -> Bool {
        
        let outputs = self.outputs().filter("index == %i && value == %i && txHash == %@",output.index,output.value,output.txHash)
        
        return !outputs.isEmpty
    }
}
