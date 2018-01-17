//
//  Double + Utils.swift
//  EmercoinOne
//

import UIKit

extension Double {
  
    func timeIntervalFormat() -> Double {
        
        var string = String(self)
        
        if string.length > 10 {
            while string.length != 10 {
               string = string.removeLast()
            }
        }
        
        return Double(string) ?? 0
    }
}
