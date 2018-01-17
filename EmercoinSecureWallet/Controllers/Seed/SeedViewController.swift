//
//  SeedViewController.swift
//  EmercoinSecureWallet
//

import UIKit

class SeedViewController: BaseViewController {

    @IBOutlet private weak var backButton:UIButton!
    @IBOutlet private weak var startButton:UIButton!
    @IBOutlet private weak var mainView:UIView!
    @IBOutlet private weak var titleLabel:UILabel!
    @IBOutlet private weak var rulesView:UITextView!
    @IBOutlet private weak var infoView:UITextView!
    @IBOutlet private weak var attentionLabel:UILabel!
    @IBOutlet private weak var readyLabel:UILabel!
    @IBOutlet private var constraints: [NSLayoutConstraint]!
    
    private var words:[String] = []
    private var wordIndex = 0
    
    private weak var generationView:SeedGenerationView?
    private weak var validationView:SeedValidationView?
    
    override class func storyboardName() -> String {
        return "Seed"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        
        let title = NSLocalizedString("Generate a new wallet", comment: "").uppercased()
        let startTitle = NSLocalizedString("Start", comment: "")
        let attentionTitle = NSLocalizedString("ATTENTION!", comment: "")
        let rulesText = NSLocalizedString("Never disclose your seed phrase.\nNever type it on a website.\nDo not store it electronically.!", comment: "")
        let infoText = NSLocalizedString("Please save the words on paper (order is important). This seed phrase will allow you to recover your wallet in case of phone failure.", comment: "")
        let readyText = NSLocalizedString("If you understand, click Start.", comment: "")
        
        titleLabel.text = title
        startButton.setTitle(startTitle, for: .normal)
        attentionLabel.text = attentionTitle
        rulesView.text = rulesText
        infoView.text = infoText
        readyLabel.text = readyText
        
        if isIphone5() {
            constraints.forEach({ (constraint) in
                constraint.constant -= 20
            })
        }
    }
    
    @IBAction internal func startButtonPressed() {
        showGenerationView()
    }
    
    private func showGenerationView() {
        
        let view = getSeedView(at: 0) as! SeedGenerationView
        
        wordIndex = 0
        
        view.nextPressed = { [weak self] in
            
            self?.wordIndex+=1
            
            if self?.wordIndex == 12 {
                self?.showValidationView()
                view.removeFromSuperview()
            } else {
                
                if let index = self?.wordIndex {
                    self?.setWord(at:index)
                }
            }
        } as (() -> (Void))
        
        view.startOverPressed = { [weak self] in
            
            self?.generateWords()
            self?.startOverGeneration()
        } as (() -> (Void))
        
        self.mainView.addSubview(view)
        self.generationView = view
        generateWords()
        setWord(at: wordIndex)
    }
    
    private func setWord(at index:Int) {
        
        if let view = generationView {
            view.word = words[index]
            view.count = wordIndex + 1
        }
    }
    
    private func startOverGeneration() {
        
        if let view = generationView {
            view.removeFromSuperview()
        }
        
        if let view = validationView {
            view.removeFromSuperview()
        }
    }
    
    private func showValidationView() {
        
        let view = getSeedView(at: 1) as! SeedValidationView
        view.validationType = .new
        
        view.nextPressed = { [weak self] in
            
            let seed = self?.words.joined(separator: " ") ?? ""
            
            DispatchQueue.global(qos: .background).async {
                
                BitcoinWalletHelper.generateAddresses(at: seed, completion: {[weak self] data, success in
                    DispatchQueue.main.async {
                        if success == false {
                            self?.validationView?.showIndicatorView(at: false)
                            self?.validationView?.enableNextButton(at: true)
                        } else if let addresses = data {
                            let addressesData = Addresses()
                            addressesData.add(addresses: addresses)
                            self?.backButton.isHidden = true
                            self?.showDoneView()
                        }
                    }
                })
            }
            
//            self?.backButton.isHidden = true
//            self?.showDoneView()
//            view.removeFromSuperview()
//            self?.generateBitcoinAddresses()
        } as (() -> (Void))
        
        view.startOverPressed = { [weak self] in
            
            self?.words.removeAll()
            self?.startOverGeneration()
        } as (() -> (Void))
        
        view.words = words
        
        self.mainView.addSubview(view)
        self.validationView = view
    }
    
    private func showDoneView() {
        let view = getSeedView(at: 2) as! SeedDoneView
        view.type = .new
        view.done = { [weak self] in
            //view.removeFromSuperview()
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                self?.showMainController()
            })
            //self?.showMainController()
        } as (() -> (Void))
        self.mainView.addSubview(view)
    }
    
    private func generateWords() {
        self.words = SeedGenerationHelper.generateWords()
    }
    
    private func getSeedView(at index:Int) -> UIView {
        return loadViewFromXib(name: "Seed", index: index, frame: mainView.bounds)
    }
    
    private func validateWords(at text:String) -> Bool {
        
        var result = false
        
        let enteredWords = text.components(separatedBy: " ")
        
        if enteredWords.count == 12 {
            
            for word in enteredWords {
                result = words.contains(word.lowercased())
                if result == false {
                    break
                }
            }
        }
        return result
    }
    
    private func showMainController() {
        AppManager.sharedInstance.isNeedLoadAllData = true
        Router.sharedInstance.showMainController()
    }

}
