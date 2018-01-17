 //
//  String + Utils.swift
//  EmercoinOne
//

import Foundation

extension String {
    
    var first: String {
        return String(characters.prefix(1))
    }
    
    var second: String {
        return String(characters.prefix(2))
    }
    
    var last: String {
        return String(characters.suffix(1))
    }
    
    var uppercaseFirst: String {
        return first.uppercased() + String(characters.dropFirst())
    }
    
    var length: Int {
        return characters.count
    }
    
    func insert(_ string:String,index:Int) -> String {
        return  String(self.characters.prefix(index)) + string + String(self.characters.suffix(self.characters.count-index))
    }
    
    func removeLast() -> String {
        return String(characters.dropLast())
    }
    
    func removeFirst() -> String {
        return String(characters.dropFirst())
    }
    
    func stringTo(_ index:Int) -> String {
        return  String(self.characters.prefix(index))
    }
    
    func replaceСommas() -> String {
        return self.replacingOccurrences(of: ",", with: ".")
    }
    
    mutating func formattedNumber() {
        self = self.replaceСommas()
        self = String.dropZeroLast(at: self)
        self = String.dropZeroFirst(at: self)
        self = self == "" ? "0.0" : self
    }
    
    static func dropZeroLast(at text:String) -> String {
        
        var string = text
        
        if string.contains(".") == false {
            return string
        }
        
        let ch = string.last
        
        if ch == "0" {
            string = string.removeLast()
            string = dropZeroLast(at:string)
        } else if ch == "." {
            string = string.removeLast()
        }
        
        return string
    }
    
    static func dropZeroFirst(at text:String) -> String {
        
        var string = text
        
        let ch = string.first
        
        if ch == "0" {
            string = string.removeFirst()
            string = dropZeroFirst(at:string)
        } else if ch == "." {
            string  = "0" + string
        }
        return string
    }
    
    static func randomStringWithLength (_ len : Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for _ in 0 ..< len {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        return randomString as String
    }
    
    static func isInfoCardType(at string:String) -> Bool {
        let infoCardRegEx = "^info:[0-9a-fA-F]{16}$"
        let infoCardTest = NSPredicate(format:"SELF MATCHES %@", infoCardRegEx)
        return infoCardTest.evaluate(with: string)
    }
    
    static func coinFormat(at number:Double) -> String {
        let string =  String(format: "%.8f", number)
        return string
    }
    
    static func exchangeCurrencyFormat(at number:Double) -> String {
        let string =  String(format: "%.8f", number)
        return string
    }
    
    static func livecoinOrderFormat(at number:Double) -> String {
        let string =  String(format: "%.5f", number)
        return string
    }
    
    func validAmount() -> Bool {
        return validData(at: "\\d{1,9}\\.(\\d{1,8})?")
    }
    
    func validBitcoinAmount() -> Bool {
        let number = Double(self) ?? 0.0
        return number != 0
    }
    
    func validEmercoinAmount() -> Bool {
        let number = Double(self) ?? 0.0
        return number >= 0.01
    }
    
    func validEmercoinAddress() -> Bool {
        return validData(at: "E{1}[A-Za-z0-9]{33}$")
    }
    
    func validSeedWord() -> Bool {
        return validData(at: "^[a-zA-Z]*$")
    }
    
    func validBitcoinAddress() -> Bool {
        return validData(at: "[1,3]{1}[A-Za-z0-9]{26,33}$")
    }
    
    func validAsHttpField() -> Bool {
        return validData(at: "[A-z!@#$%^&*()_+-=?~<|\\>0-9]+$")
    }
    
    func validNVSName() -> Bool {
        return validData(at: "[A-z !@#$%^&*():;/|\\-+{}\\[\\]\\?<>\\.,~=`\"0-9]+$")
    }
    
    func containOnlyZero() -> Bool {
        return validData(at: "(?!^0+$)^.{1,}")
    }
    
    private func validData(at pattern:String) -> Bool {
        let regex = try! NSRegularExpression(pattern:pattern, options:[])
        let nsString = self as NSString
        let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))
        let strings = results.map{nsString.substring(with: $0.range)}
        return strings.first != nil && strings.first == self
    }
    
    static func validEmail(email:String?) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    static func validPassword(password:String?) -> Bool {
        let passwordRegEx = "(?!^\\d+$)^.{8,128}$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: password)
    }
    
    func addingPercentEncodingForURLQueryValue() -> String? {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
}
