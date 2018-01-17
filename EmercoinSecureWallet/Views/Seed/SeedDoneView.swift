//
//  SeedDoneView.swift
//  EmercoinSecureWallet
//

import UIKit

class SeedDoneView: UIView {
    
    @IBOutlet weak var textLabel:UILabel!
    @IBOutlet weak var doneButton:UIButton!
    
    var type:SeedValidationType = .new {
        didSet {
            updateUI()
        }
    }
    
    var done:(() -> (Void))?
    
    func updateUI() {
        
        var text = NSLocalizedString("seedDoneGeneration", comment: "")
        
        if type == .repair {
            text = NSLocalizedString("seedDoneRestoring", comment: "")
        }
        textLabel?.text = text
        doneButton.setTitle(NSLocalizedString("Done", comment: ""), for: .normal)
    }
    
    @IBAction func doneButtonPressed() {
        
        doneButton.isEnabled = false
        
        if done != nil {
            done!()
        }
    }
}
