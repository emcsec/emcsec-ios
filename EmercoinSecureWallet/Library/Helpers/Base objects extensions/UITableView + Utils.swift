//
//  UITableView + Utils.swift
//  EmercoinOne
//

import Foundation
import UIKit

extension UITableView {
    
    func baseSetup() {
        self.hideEmtyCells()
        self.enableAutolayout()
    }
    
    func hideEmtyCells() {
        tableFooterView = UIView()
    }
    
    func enableAutolayout() {
        rowHeight = UITableViewAutomaticDimension
        estimatedRowHeight = 66.0
    }
    
    func reload() {
        reloadData()
    }
    
    func endRefreshing() {
        
        let refresh = self.refreshControl
        if refresh?.isRefreshing == true  {
            refresh?.endRefreshing()
        }
    }
}
