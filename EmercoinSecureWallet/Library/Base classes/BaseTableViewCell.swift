//
//  BaseTableViewCell.swift
//  EmercoinOne
//

import UIKit

class BaseTableViewCell: UITableViewCell {

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
