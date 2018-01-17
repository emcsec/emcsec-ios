//
//  SeedValidationView.swift
//  EmercoinSecureWallet
//

import UIKit

enum SeedValidationType {
    case new
    case repair
}

class SeedValidationView: UIView {

    @IBOutlet var seedTextFields: [SeedTextField]!
    @IBOutlet internal weak var titleLabel:UILabel!
    @IBOutlet internal weak var nextButton:RoundButton!
    @IBOutlet internal weak var startOverButton:UIButton!
    @IBOutlet internal weak var overView:UIView!
    @IBOutlet internal weak var seedView:UIView!
    @IBOutlet internal weak var activityView:UIView!
    @IBOutlet internal weak var seedViewwidthConstraint:NSLayoutConstraint!
    
    var validationType:SeedValidationType = .new {
        didSet {
            updateUI()
        }
    }
    
    var nextPressed:(() -> (Void))?
    var startOverPressed:(() -> (Void))?
    
    var words:[String] = []
    
    var isValide:Bool = false {
        didSet{
            nextButton.isEnabled = isValide
        }
    }
    
    func updateUI() {
        
        titleLabel?.text = NSLocalizedString("Enter please all the seed phrase words to the input fields", comment: "")
        
        var nextTitle = NSLocalizedString("Next", comment: "")
        
        if validationType == .repair {
            overView.isHidden = true
            nextTitle = NSLocalizedString("Repair", comment: "")
        }
        
        nextButton.setTitle(nextTitle, for: .normal)
        startOverButton.setTitle(NSLocalizedString("Start over", comment: ""), for: .normal)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        seedViewwidthConstraint.constant = frame.size.width
        showIndicatorView(at: false)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        seedTextFields.forEach {[weak self] (seedTextField) in
            
            seedTextField.placeholder = NSLocalizedString("Word", comment: "") + " \(seedTextField.tag + 1)"
            
            seedTextField.textChanged = {[weak self] text, index in
                
                if self?.validationType == .new {
                    self?.validateWord(at: text, index: index, seedTextField: seedTextField)
                } else {
                    self?.baseValide()
                }
            }
            seedTextField.returnKeyPressed = {
                
                self?.textFieldReturnKeyPressed(seedTextField)
            }
            
            //seedTextField.keyboardToolbar.isHidden = true
        }
    }
    
    private func baseValide() {
        
        let valids = seedTextFields.filter{$0.text?.isEmpty == false}
        self.isValide = valids.count == 12
    }
    
    private func validateWord(at text:String, index:Int, seedTextField:SeedTextField) {
        
        if index < words.count {
            let word = words[index]
            
            let isValid = text.isEmpty ? true : word == text
            
            seedTextField.isValid = isValid
            
            let valids = seedTextFields.filter{$0.isValid == true && $0.text?.isEmpty == false}
            self.isValide = valids.count == words.count
        }
    }
    
    func textFieldReturnKeyPressed(_ textField: UITextField?) {
        
        if let textField = textField {
            if textField.returnKeyType == .next {
                let index = textField.tag + 1
                
                seedTextFields.forEach({ (seedTextField) in
                    if seedTextField.tag == index {
                        seedTextField.becomeFirstResponder()
                        textField.resignFirstResponder()
                    }
                })
            } else {
                textField.resignFirstResponder()
            }
        }
    }
    
    func showIndicatorView(at state:Bool) {
        self.activityView.isHidden = !state
    }
    
    func enableNextButton(at state:Bool) {
        nextButton.isEnabled = state
    }
    
    @IBAction func nextButtonPressed() {
    
        print("nextButtonPressed")
        
        if !nextButton.isEnabled {
            return
        }
        
        DispatchQueue.main.async {
            self.showIndicatorView(at: true)
            self.enableNextButton(at: false)
        }
        
        if validationType == .repair {
            words = seedTextFields.sorted{$0.tag < $1.tag}.map{$0.text ?? ""}
        }
        
        if nextPressed != nil {
            nextPressed!()
        }
    }
    
    @IBAction func startOverButtonPressed() {
        
        if startOverPressed != nil {
            startOverPressed!()
        }
    }
}
