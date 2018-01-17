//
//  BaseSwipeTableViewCell.swift
//  EmercoinSecureWallet
//

import UIKit
import SwipeCellKit

class BaseSwipeTableViewCell: SwipeTableViewCell {

    var object:Any? {
        didSet {
            updateUI()
        }
    }
    
    var pressedCell: ((_ indexPath:IndexPath) -> (Void))?
    var indexPath:IndexPath?
    var isExpanded:Bool = false
    
    func updateUI() {
        
    }
}
