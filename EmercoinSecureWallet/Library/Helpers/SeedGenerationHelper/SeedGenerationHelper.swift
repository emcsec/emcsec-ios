//
//  SeedGenerationHelper.swift
//  EmercoinSecureWallet
//

import UIKit

class SeedGenerationHelper: NSObject {
    
    class func generateWords() -> [String] {
    
        let words = NYMnemonic.generateString(128, language: "english").components(separatedBy: " ")
        return words
    }
}
