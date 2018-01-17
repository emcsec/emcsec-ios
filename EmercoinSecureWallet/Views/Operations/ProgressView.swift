//
//  ProgressView.swift
//  EmercoinSecureWallet
//

import UIKit

class ProgressView: PleaseWaitView {

    @IBOutlet weak var progressLabeL:UILabel!
    
    func updateProgress(at object:Any) {
        
        if let dict = object as? [String:Any] {
            
            guard let currentValue = dict["current"] as? Int, let totalValue = dict["total"] as? Int else {
                return
            }
            
            progressLabeL.text = String(format:"%i / %i",currentValue,totalValue)
        }
    }
}
