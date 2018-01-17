//
//  History.swift
//  EmercoinOne
//

import UIKit
import RxCocoa
import RxSwift
import RealmSwift


class History: NSObject {
    
    var type:CoinType = .emercoin
    
    let disposeBag = DisposeBag()
    var completion = PublishSubject<Bool>()
    
    func transactions(confirmed:Bool) -> Results<HistoryTransaction> {
        let realm = try! Realm()
        return realm.objects(HistoryTransaction.self).filter("isConfirmed == %i && type == %@",confirmed,type.sign())
    }
    
    func allTransactions() -> Results<HistoryTransaction> {
        let realm = try! Realm()
        return realm.objects(HistoryTransaction.self).filter("type == %@",type.sign())
    }
    
    func totalCount() -> Int {
        let tx = transactions(confirmed: true)
        let unTx = transactions(confirmed: false)
        return tx.count + unTx.count
    }
    
    func add(transaction:HistoryTransaction) {
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(transaction)
        }
    }
    
    func add(transactions:[HistoryTransaction]) {
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(transactions)
        }
    }
    
    func remove(transaction:HistoryTransaction) {
        
        let realm = try! Realm()
        try! realm.write {
            realm.delete(transaction)
        }
    }
    
    func removeAll() {
        
        let realm = try! Realm()
        try! realm.write {
            realm.delete(transactions(confirmed: true))
            realm.delete(transactions(confirmed: false))
        }
    }
    
    func existFillTransaction(at txHash:String) -> Bool {
        
        var result = false
        
        let txs = allTransactions().filter("txID == %@",txHash)
            
        for tx in txs {
            result = tx.isConfirmed && !tx.txRaw.isEmpty && tx.blockheight > 0 && tx.timeInterval > 0
        }
        
        return result
    }
    
    func processingAndAdd(at transactions:[HistoryTransaction]) {
        
        removeAll()
        add(transactions: transactions)
//        let all = Array(allTransactions())
//        print(allTransactions())
//
//        let outTxs = all.filter{$0.direction() == .outcoming}
        
        //print(outTxs)
    }
    
    func load() {
        let api = NetworkManager()
        api.completion = { data in
            self.completion.onNext(true)
        }
        api.loadHistory(at: type)
    }
}
