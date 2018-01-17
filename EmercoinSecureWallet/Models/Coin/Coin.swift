//
//  Coin.swift
//  EmercoinBasic
//
import UIKit

enum CoinType:Int{
    case bitcoin
    case emercoin
    
    func sign() -> String {
        return self == .bitcoin ? "BTC" : "EMC"
    }
    
    func fullName() -> String {
        var name = ""
        switch self {
        case .bitcoin:name = "Bitcoin"
        case .emercoin:name = "Emercoin"
        }
        return name
    }
    
    init(name: String) {
        switch name.lowercased() {
        case "emc": self = .emercoin
        case "btc": self = .bitcoin
        default:self = .emercoin
        }
    }
}

let satoshiInBitcoin = 100000000
let satoshiInEmercoin = 1000000

class Coin {
    
    var name:String?
    var amount:Int {
        let addresses = Addresses()
        addresses.type = type
        let bal = addresses.allAddresses.map{$0.balance}.reduce(0, {$0 + $1})
        return bal
    }
    
    var image:String?
    var sign = "BTC"
    var currencySign = "USD"
    var color:String?
    var priceCurrency:Double = 0
    var currencyType:CurrencyType = .usd {
        didSet {
            currencySign = currencyType.description()
        }
    }
    var type:CoinType = .bitcoin {
        didSet {
            if type == .bitcoin {
                sign = "BTC"
            } else {
                sign = "EMC"
            }
        }
    }
    
    func standartAmount() -> Double {
        let inSatoshi = type == .emercoin ? satoshiInEmercoin : satoshiInBitcoin
        return Double(amount) / Double(inSatoshi)
    }

    func stringAmount() -> String {
        return String.dropZeroLast(at: String.coinFormat(at:standartAmount()))
    }
    
    func coinInCurrency() -> Double {
        return standartAmount() * priceCurrency
    }
    
    func exchangeAttributedString(color:UIColor? = nil) -> NSAttributedString {
        
        var fontSize:CGFloat = 15.0
        
        if isIphone5() {
            fontSize = priceCurrency > 99 ? 12.0 : 15.0
        }
        
        let amountAttributes = [NSAttributedStringKey.foregroundColor: color ?? .gray, NSAttributedStringKey.font:UIFont.systemFont(ofSize: fontSize)]
        
        let otherAttributes = [NSAttributedStringKey.foregroundColor: color ?? .lightGray, NSAttributedStringKey.font:UIFont.systemFont(ofSize: fontSize)]
        
        let coinsInFiat = String(format:"%0.2f",coinInCurrency())
        
        let part1 = NSMutableAttributedString(string: "~"+coinsInFiat, attributes: amountAttributes)
        let part2 = NSMutableAttributedString(string: " \(currencySign)", attributes: otherAttributes)
        let part3 = NSMutableAttributedString(string: "      ", attributes: otherAttributes)
        let part4 = NSMutableAttributedString(string: "(", attributes: otherAttributes)
        let part5 = NSMutableAttributedString(string: "1 ", attributes: amountAttributes)
        let part6 = NSMutableAttributedString(string: sign+" = ", attributes: otherAttributes)
        let part7 = NSMutableAttributedString(string: String(format:"%0.2f",priceCurrency), attributes: amountAttributes)
        let part8 = NSMutableAttributedString(string: ")", attributes: otherAttributes)
        
        let parts = [part1,part2,part3,part4,part5,part6,part7,part2,part8]
        
        let combination = NSMutableAttributedString()
        
        for part in parts {
            combination.append(part)
        }
        return combination
    }
}
