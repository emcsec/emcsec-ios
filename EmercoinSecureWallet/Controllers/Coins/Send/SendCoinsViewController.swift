//
//  SendCoinsViewController.swift
//  EmercoinOne
//

import UIKit
import RxSwift
import RxCocoa

enum FeeType:Int {
    case recommend
    case custom
}

class SendCoinsViewController: BaseViewController, IndicatorInfoProvider {
    
    private let feeValues = [0.00136222,0.00148372,0.00162258,0.00179907,0.00199912]
    private var feeRecValue = 0.00179907
    private var feeCustomValue = 0.00001
    private let minFee = 0.00001
    
    private var feeType:FeeType = .recommend {
        didSet {
            updateFeeSettings()
            checkValidation()
        }
    }
    
    @IBOutlet internal weak var recFeeButton:CheckButton!
    @IBOutlet internal weak var customFeeButton:CheckButton!
    @IBOutlet internal weak var feeLabel:UILabel!
    @IBOutlet internal weak var feeCustomLabel:UILabel!
    @IBOutlet internal weak var feeRecLabel:UILabel!
    @IBOutlet internal weak var feeMinLabel:UILabel!
    @IBOutlet internal weak var feeSegmentedControl:UISegmentedControl!
    @IBOutlet internal weak var feeSlider:BaseSlider!
    @IBOutlet internal weak var feeViewHeightConstraint:NSLayoutConstraint!
    @IBOutlet internal weak var feeView:UIView!
    @IBOutlet internal weak var feeRecOverlayView:UIView!
    @IBOutlet internal weak var feeCustomView:UIView!
    @IBOutlet internal weak var operationLabel:UILabel!
    @IBOutlet internal weak var amountLabel:UILabel!
    @IBOutlet internal weak var feeTextLabel:UILabel!
    
    @IBOutlet internal weak var addressTextField:BaseTextField!
    @IBOutlet internal weak var feeTextField:BaseTextField!
    @IBOutlet internal weak var signLabel:UILabel!
    @IBOutlet internal weak var sendButton:BaseButton!
    @IBOutlet internal weak var sendButtonTopConstraint:NSLayoutConstraint!
    @IBOutlet internal weak var amountTextField:BaseTextField!
    
    @IBOutlet internal weak var viewWidthConstraint:NSLayoutConstraint!
    
    private var amount:Double = 0
    
    var coinType:CoinType = .emercoin
    
    let disposeBag = DisposeBag()
    private var viewModel = SendViewModel()
    
    override class func storyboardName() -> String {
        return "CoinsOperation"
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title:coinType.fullName())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSend()
        setupConstraints()
        updateUI()
    }
    
    private func updateFeeSettings() {
        
        let isRecommendFee = feeType == .recommend
        recFeeButton.isCheked = isRecommendFee
        customFeeButton.isCheked = !isRecommendFee
        feeRecOverlayView.isHidden = isRecommendFee
        feeCustomView.isHidden = !isRecommendFee
    }
    
    override func setupUI() {
        super.setupUI()
        
        customFeeButton.isCheked = false
        recFeeButton.isCheked = true
        
        
        sendButton.setTitle(NSLocalizedString("Send", comment: ""), for: .normal)
        amountLabel.text = NSLocalizedString("Amount", comment: "") + ":"
        feeTextLabel.text = NSLocalizedString("Fee", comment: "") + " (BTC/Kb):"
        feeRecLabel.text = NSLocalizedString("Recommended", comment: "") + ":"
        feeCustomLabel.text = NSLocalizedString("Custom", comment: "") + ":"
        var fee = String.coinFormat(at: minFee)
        fee.formattedNumber()
        feeMinLabel.text = NSLocalizedString("Minimum", comment: "") + " \(fee)"
        operationLabel?.text = NSLocalizedString("Send Coins", comment: "")
        addressTextField?.placeholder = NSLocalizedString("Enter an address", comment: "")
        
        hideStatusBar()
        
        viewModel.colorString.subscribe(onNext:{[weak self] color in
            self?.sendButton.enableColor = color
            self?.operationLabel.textColor = UIColor(hexString: color)
        }).disposed(by: disposeBag)
        viewModel.coinSign.bind(to: signLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.coinType = coinType
        
        
        if let fee = Settings.userFee {
            feeRecValue = fee.recommended
            feeCustomValue = fee.custom
            
            if let index = feeValues.index(of: fee.recommended) {
                feeSlider.value = Float(index)
            }
            
            updateFee()
        }
        
        if object != nil {
            guard let dict = object as? [String:Any] else {
                return
            }
            
            guard let address = dict["address"] as? String else {
                return
            }
            addressTextField.text = address
            
            guard let amount = dict["amount"] as? String else {
                return
            }
            amountTextField.text = String.dropZeroLast(at: amount)
            
            self.checkValidation()
        }
    }
    
    private func updateUI() {
        
        viewWidthConstraint.constant = screenSize().size.width
    }
    
    private func setupConstraints() {
    
        if isIphone5() && coinType == .emercoin {
            sendButtonTopConstraint.constant = 75
        }
        
        if coinType == .emercoin {
            feeViewHeightConstraint.constant = 0
            sendButtonTopConstraint.constant = 75
            feeView.isHidden = true
        }
    }
    
    private func updateFee() {
        
        feeLabel.text = String(format:"%0.8f",feeRecValue)
        feeTextField.text = String(feeCustomValue)
    }
    
    private func saveUserFee() {
        let fee = UserFee()
        fee.recommended = self.feeRecValue
        
        if feeType == .recommend {
            fee.custom = fee.recommended
        } else {
            fee.custom = self.feeCustomValue
        }
        Settings.addUserFee(at: fee)
    }
    
    private func setupSend() {
        
        viewModel.completion.subscribe(onNext:{[weak self] success in
            if success {
                showSuccessOperationView(completion: {
                    self?.saveUserFee()
                    let wallet = AppManager.sharedInstance.wallet
                    if let type = self?.coinType {
                        wallet.loadBalance(at: type)
                        self?.back()
                    }
                })
            }
        }).disposed(by: disposeBag)
        
        viewModel.error.subscribe(onNext:{[weak self] error in
            showErroViewAlert(error: error)
        }).disposed(by: disposeBag)
        
        addressTextField.textChanged = {[weak self](text) in
            self?.checkValidation()
        }
        
        amountTextField.textChanged = {[weak self](text) in
            self?.checkValidation()
        }
        
        feeTextField.textChanged = {[weak self](text) in
            
            var fee = text
            fee.formattedNumber()
            
            self?.feeCustomValue = Double(fee) ?? 0
            
            self?.checkValidation()
        }
    }
    
    private func checkValidation() {
        
        let address = addressTextField.text ?? ""
        var amount = amountTextField.text ?? ""
        amount = amount.replaceСommas()
        
        let isValidAddress = coinType == .bitcoin ? address.validBitcoinAddress() : address.validEmercoinAddress()
        let isValidAmount = coinType == .bitcoin ? amount.validBitcoinAmount() : amount.validEmercoinAmount()
        let isValidFee = feeType == .recommend ? true : feeCustomValue >= minFee
        
        sendButton.isEnabled = isValidAddress  && isValidAmount && isValidFee
    }
    
    private func addRequestSendView() {
    
        var amount = amountTextField.text ?? ""
        amount.formattedNumber()
        self.amount = Double(amount) ?? 0
        
        let address = addressTextField.text ?? ""
        
        if amount.length > 0 && address.length > 0  {
            
            let requestSendView:RequestSendView! = loadViewFromXib(name: "Operations", index: 6,
                                                                   frame: self.parent!.view.frame) as! RequestSendView
            let requestText = NSLocalizedString("Do you want to send to this address", comment: "")
            let requestString = String(format:"%@ %@ %@?",requestText,amount,coinType.sign())
            
            requestSendView.amountLabel?.text = requestString
            requestSendView.coinType = coinType
            requestSendView.done = ({[weak self] in
                
                self?.sendTransaction()
                
            })
             self.parent?.view.addSubview(requestSendView)
        }
    }
    
    private func sendTransaction(password:String? = nil) {
        
        let address = addressTextField.text ?? ""
        let dAmount = Double(self.amount)
        let bitcoinFee = feeType == .recommend ? feeRecValue : feeCustomValue
        let fee = coinType == .emercoin ? 0.0001 : bitcoinFee / 1000.0
        let data:[String:Any] = ["address":address,"amount":dAmount,
                    "type":self.coinType, "fee":fee]
        print(fee)
        self.viewModel.newTransaction(at: data)
    }
    
    @IBAction func sendButtonPressed(sender:UIButton) {
        print("sendButtonPressed")
        
        addRequestSendView()
    }
    
    @IBAction internal func changeValueFeeSlider(sender:UISlider) {
        let index = Int(sender.value)
        
        if index < feeValues.count {
            feeRecValue = feeValues[index]
            viewModel.wallet.feeIndex = index
            updateFee()
        }
    }
    
    @IBAction internal func feeButtonPressed(sender:UIButton) {
        
        feeType = FeeType(rawValue: sender.tag) ?? .recommend
    }
}
