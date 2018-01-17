//
//  RoundView.swift
//  EmercoinSecureWallet
//

import UIKit

class RoundView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI() {
        
        //let color = UIColor(hexString: "CCCCCC")
        let color = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0) //- default
        let borderWidth = 1.0
        let cornerRadius = 10.0
        
        fullyRound(diameter: CGFloat(cornerRadius), borderColor: color, borderWidth: CGFloat(borderWidth))
    }

}
