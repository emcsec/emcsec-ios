
//
//  Date + Utils.swift
//  EmercoinOne
//

import UIKit

extension Date {
    
    func stringDate() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let dateString = dateFormatter.string(from:self)
        return dateString
    }
    
    func transactionStringDate() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from:self)
        return dateString
    }
    
    func transactionStringTime() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let dateString = dateFormatter.string(from:self)
        return dateString
    }
    
    func transactionStringDateFull() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let dateString = dateFormatter.string(from:self)
        return dateString
    }
    
    static func fromString(string:String) -> Date {
    
        let dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return date(at: string, format: dateFormat, isUTCTimeZone: true)
    }
    
    static func fromBTC38String(string:String) -> Date {
        
        let dateFormat = "yyyy-MM-dd HH:mm:ss"
        return date(at: string, format: dateFormat, isUTCTimeZone: false)
    }
    
    
    private static func date(at string:String, format:String, isUTCTimeZone:Bool ) -> Date {
     
        let dateFormatter = DateFormatter()
        
        if isUTCTimeZone {
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
        }
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: string)
        return date ?? Date()
    }
    
    init(at string: String) {
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy"
        
        guard let date = df.date(from: string) else {
            self.init(timeIntervalSince1970: Date().timeIntervalSince1970)
            return
        }
        self.init(timeIntervalSince1970: date.timeIntervalSince1970)
    }
}


