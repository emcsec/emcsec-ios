//
//  SLLinkLabel.swift
//  EmercoinOne
//

import UIKit

class SLLinkLabel: UILabel {
    
    var pressedLink: ((_ link:String) -> (Void))?
    
    var linkColor = UIColor(red:28/255.0, green:135/255.0, blue:199/255.0, alpha:1)
    var baseColor = UIColor.black
    var headerColor = UIColor.black
    
    var linkFont = UIFont.systemFont(ofSize: 14.0)
    var baseFont = UIFont.systemFont(ofSize: 14.0)
    var headerFont = UIFont.boldSystemFont(ofSize: 14.0)
    
    var links:[String] = []
    
    var headers:[String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        self.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func tapHandler(sender:UITapGestureRecognizer){
        
        let text = self.text ?? ""
        
        for link in links {
            let range = (text as NSString).range(of: link)
            if sender.didTapAttributedTextInLabel(label: self, inRange: range) {
                if pressedLink != nil {
                    pressedLink!(link)
                }
                break
            }
        }
    }
    
    func update() {
        
        let text = self.text ?? ""
        
//        let attributesLink = [NSForegroundColorAttributeName: linkColor,
//                              NSFontAttributeName: linkFont,NSUnderlineStyleAttributeName:NSUnderlineStyle.styleSingle.rawValue] as [String : Any]
//        let attributes = [NSForegroundColorAttributeName: baseColor,
//                          NSFontAttributeName: baseFont] as [String : Any]
//        let headerAttributes = [NSForegroundColorAttributeName:headerColor,
//                                NSFontAttributeName:headerFont] as [String : Any]
        
        let attributesLink = [NSAttributedStringKey.foregroundColor: linkColor,
                              NSAttributedStringKey.font: linkFont] as [NSAttributedStringKey : Any]
        let attributes = [NSAttributedStringKey.foregroundColor: baseColor,
                          NSAttributedStringKey.font: baseFont] as [NSAttributedStringKey : Any]
        let headerAttributes = [NSAttributedStringKey.foregroundColor:headerColor,
                                NSAttributedStringKey.font:headerFont] as [NSAttributedStringKey : Any]
        
        let attText = NSMutableAttributedString(string:text)
        
        let fullRange = NSMakeRange(0, (text as NSString).length)
        
        attText.addAttributes(attributes, range: fullRange)
        
        for link in links {
            
            let range = (text as NSString).range(of: link)
            attText.addAttributes(attributesLink, range: range)
        }
        
        for header in headers {
            let range = (text as NSString).range(of: header)
            attText.addAttributes(headerAttributes, range: range)
        }
        
        attributedText = attText
    }
}

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        
        let locationOfTouchInTextContainer = CGPoint(x:locationOfTouchInLabel.x - textContainerOffset.x, y:
            locationOfTouchInLabel.y - textContainerOffset.y);
        
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}
