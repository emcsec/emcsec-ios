//
//  Array + Utils.swift
//

import UIKit

extension Array {
    
    func convertElementsToStrings() -> [String] {
        
        return map{String(describing: $0)}
    }
}

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}
