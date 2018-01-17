//
//  AboutViewController.swift
//  EmercoinBasic
//

import UIKit

let aboutText = NSLocalizedString("aboutText", comment: "")

class AboutViewController: BaseViewController {

    @IBOutlet internal weak var textLabel:SLLinkLabel!
    @IBOutlet internal weak var titleLabel:UILabel!
    
    private var basicLink = "https://www.aspanta.com/project/emcbasic"
    private var emerLink = "https://www.emercoin.net"
    private var aspantaLink = "https://www.aspanta.com"
    
    private var basic = "«Emercoin Basic»"
    private var emer = "«Emercoin»"
    private var aspanta = "Aspanta Limited"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupUI() {
        super.setupUI()
        
        titleLabel?.text = NSLocalizedString("mobile wallet", comment: "").uppercased()
        
        textLabel.text = aboutText
        textLabel.links = [basic,emer,aspanta]
        
        textLabel.pressedLink = {link in
            
            switch link {
            case self.basic:self.moveTo(at: self.basicLink)
            case self.emer:self.moveTo(at: self.emerLink)
            case self.aspanta:self.moveTo(at: self.aspantaLink)
            default:
                break
            }
        }
        
        textLabel.update()
    }
    
    func moveTo(at stringUrl:String) {
        
        if let url = URL(string: stringUrl) {
            UIApplication.shared.open(url, options: [:])
        }
    }

    override class func storyboardName() -> String {
        return "About"
    }
}
