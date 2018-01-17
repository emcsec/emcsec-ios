//
//  SeedGenerationView.swift
//  EmercoinSecureWallet
//

import UIKit

class SeedGenerationView: UIView {

    @IBOutlet internal weak var nextButton:RoundButton!
    @IBOutlet internal weak var startOverButton:UIButton!
    @IBOutlet internal weak var wordLabel:UILabel!
    @IBOutlet internal weak var countLabel:UILabel!
    @IBOutlet internal weak var titleLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateUI()
    }
    
    var word:String? {
        didSet {
            wordLabel.text = word ?? ""
        }
    }
    
    var count:Int? {
        didSet {
            
            let ofText = NSLocalizedString("of", comment: "")
            
            countLabel.text = String(format:"%@ %i %@ 12",NSLocalizedString("Word", comment: ""), count ?? 1, ofText)
            if count == 12 {
                nextButton.setTitle(NSLocalizedString("Next", comment: ""), for: .normal)
            }
        }
    }
    
    var nextPressed:(() -> (Void))?
    var startOverPressed:(() -> (Void))?
    
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        
    }
    
    private func updateUI() {
        titleLabel?.text = NSLocalizedString("Please write down this word", comment: "")
        startOverButton.setTitle(NSLocalizedString("Start over", comment: ""), for: .normal)
        nextButton.setTitle(NSLocalizedString("Next word", comment: ""), for: .normal)
    }
    
    @IBAction func nextButtonPressed() {
        
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
