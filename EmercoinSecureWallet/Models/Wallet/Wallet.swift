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
            
            loadExchangeCourses()
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
        
        self.loadExchangeCourses()
        
        let api = NetworkManager()
        api.completion = { data in
            self.completion.onNext(true)
        }
        api.loadBalances()
    }
    
    func loadBalance(at type:CoinType) {
        
        self.loadExchangeCourses()
        
        let api = NetworkManager()
        api.completion = { data in
            self.completion.onNext(true)
        }
        api.loadBalance(at: type)
    }
    
    func loadExchangeCourses() {
        self.loadExchangeCourse(at: .bitcoin) { (price) in
            self.bitcoin.priceCurrency = price
        }
        self.loadExchangeCourse(at: .emercoin) { (price) in
            self.emercoin.priceCurrency = price
        }
    }
    
    private func loadExchangeCourse(at coin:CoinType, completion:@escaping (_ price: Double) -> Void) {
        let api = APIManager()
        api.loadCoinExchangeRates(at: currencyType, coin: coin, completion: completion)
    }
    
    func update() {
        self.completion.onNext(true)
    }
}
