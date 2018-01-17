//
//  BaseTextViewController.swift
//  EmercoinBasic
//

import UIKit

class BaseTextViewController: BaseViewController {

    @IBOutlet weak var scrollView:UIScrollView!
    @IBOutlet weak var logoView:UIView!
    @IBOutlet weak var textView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let width = view.frame.size.width
        
        scrollView.contentSize.width = width
        
        if let view = logoView {
            view.frame.size.width = width
        }
        
        if let view = textView {
            view.frame.size.width = width
        }
    }
}
