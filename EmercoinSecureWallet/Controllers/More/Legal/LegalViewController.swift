//
//  TermOfUseViewController.swift
//  EmercoinBasic
//

import UIKit

class LegalViewController: BaseTextViewController {
    
    @IBOutlet internal weak var textLabel:UILabel!
    @IBOutlet internal weak var urlLabel:SLLinkLabel!
    @IBOutlet internal weak var headerLabel:UILabel!
    
    var viewModel:LicenseViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
    }

    override class func storyboardName() -> String {
        return "Legal"
    }
    
    func updateUI() {
        
        if let viewModel = viewModel {
         
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = NSTextAlignment.left
            
            let size:CGFloat = viewModel.text.length > 20000 ? 12.0 : 14.0
            
            let font = UIFont.systemFont(ofSize: size)
            let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black,
                              NSAttributedStringKey.font: font]
            
            let body = NSMutableAttributedString(string:viewModel.text, attributes: attributes)
    
            headerLabel.text = viewModel.name + " License"
            textLabel.attributedText = body
            
            urlLabel.text = viewModel.url + "\n"
            urlLabel.links = [viewModel.url]
            
            urlLabel.pressedLink = {link in
                
                if let url = URL(string: link) {
                    UIApplication.shared.open(url, options: [:])
                }
            }
            urlLabel.update()
        }
    }
}

