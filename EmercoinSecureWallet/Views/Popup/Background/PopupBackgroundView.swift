//
//  PopupBackgroundView.swift
//  EmercoinOne
//

import UIKit

class PopupBackgroundView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        fullyRound(diameter: 60, borderColor: .clear, borderWidth: 0.0)
    }

}
