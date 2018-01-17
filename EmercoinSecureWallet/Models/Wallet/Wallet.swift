//
//  Wallet.swift
//  EmercoinOne
//

import UIKit
import RxCocoa
import RxSwift

enum CurrencyType:Int {
    case usd = 0
    case eur = 1
    case cny = 2
    case rur = 3
    case btc = 4
    case emc = 5
    
    init(name: String) {
        switch name {
        case "USD": self = .usd
        case "EUR": self = .eur
        case "CNY": self = .cny
        case "RUR": self = .rur
        case "BTC": self = .btc
        case "EMC": self = .emc
        default:self = .usd
        }
    }
    
    func description(forApi state:Bool = false) -> String {
        var string = ""
        switch self {
        case .usd:string = "USD"
        case .eur:string = "EUR"
        case .cny:string = "CNY"
        case .rur:string = state ? "RUB" : "RUR"
        case .btc:string = "BTC"
        case .emc:string = "EMC"
        }
        return string
    }
}

class Wallet {
    
    var currencyType:CurrencyType = .usd {
        didSet {
            bitcoin.currencyType = currencyType
            emercoin.currencyType = currencyType
            
            loadCourse()
        }
    }
    
    var completion = PublishSubject<Bool>()
    
    var bitcoin:Coin
    var emercoin:Coin
    
    var emcInBit = 100.0
    var bitInEmc = 0.0001
    var feeIndex = 1
    
    var isEnabledSpendingPassword = false
    
    init() {
        
        let emCoin = Coin()
        emCoin.name = "EMERCOIN"
        //emCoin.balance = 5.21
        emCoin.image = "emer_icon_1"
        emCoin.sign = "EMC"
        emCoin.color = Constants.Colors.Coins.Emercoin
        emCoin.type = .emercoin
        
        let  bCoin = Coin()
        bCoin.name = "BITCOIN"
        //bCoin.balance = 0.0
        bCoin.image = "bit_icon_1"
        bCoin.sign = "BTC"
        bCoin.color = Constants.Colors.Coins.Bitcoin
        bCoin.type = .bitcoin
        
        self.bitcoin = bCoin
        self.emercoin = emCoin
    }
    
    func exchangeRateBitcoinInEmercoin() -> String {
        return String(format:"1 EMC = %0.4f BTC",bitInEmc)
    }
    
    func exchangeRateEmercoinInBitcoin() -> String {
        return String(format:"1 BTC = %0.4f EMC",emcInBit)
    }
    
    func stubMyAddresses() -> [String] {
        return [""]
    }
    
    func loadBalances() {
        let api = NetworkManager()
        api.completion = { data in
            self.completion.onNext(true)
            self.loadCourse()
        }
        api.loadBalances()
    }
    
    func loadBalance(at type:CoinType) {
        let api = NetworkManager()
        api.completion = { data in
            self.completion.onNext(true)
            self.loadCourse()
        }
        api.loadBalance(at: type)
    }
    
    func loadCourse() {
        let api = APIManager()
        api.loadEmercoinCourse(at: currencyType) {[weak self] (data) in
            if let priceCurrency = data as? String {
                self?.emercoin.priceCurrency = Double(priceCurrency) ?? 0.0
                self?.completion.onNext(true)
            }
        }
        api.loadBitcoinCourse(at: currencyType) {[weak self] (data) in
            if let priceCurrency = data as? String {
                self?.bitcoin.priceCurrency = Double(priceCurrency) ?? 0.0
                self?.completion.onNext(true)
            }
        }
    }
    
    func update() {
        self.completion.onNext(true)
    }
}
