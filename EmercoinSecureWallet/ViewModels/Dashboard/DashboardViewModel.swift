//
//  HomeViewModel.swift
//  EmercoinOne
//

import UIKit
import RxSwift
import RxCocoa

class DashboardViewModel:SendViewModel {
    
    override init() {
        
        super.init()
        
        wallet.completion.subscribe(onNext: {[weak self] (state) in
            self?.updateUI()
            self?.walletCompletion.onNext(state)
        }).disposed(by: disposeBag)
    }
    
    func updateWallet() {
        wallet.loadBalances()
    }
    
    func loadAllData() {
        
        isLoading = true
        
        let api = NetworkManager()
        
        api.completion = { data in
            self.isLoading = false
            AppManager.sharedInstance.isNeedLoadAllData = false
            self.walletCompletion.onNext(true)
        }
        api.loadAllData()
        
        wallet.loadCourse()
    }
    
    func loadCourses() {
        wallet.loadCourse()
    }
}
