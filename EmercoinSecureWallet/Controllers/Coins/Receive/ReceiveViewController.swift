//
//  GetCoinsViewController.swift
//  EmercoinOne
//

import UIKit
import RxSwift
import RxCocoa

class ReceiveViewController: BaseViewController, IndicatorInfoProvider {
    
    @IBOutlet internal weak var coinSignLabel:UILabel!
    @IBOutlet internal weak var addressLabel:UILabel!
    @IBOutlet internal weak var amountTextField:BaseTextField!
    @IBOutlet internal weak var amountLabel:UILabel!
    @IBOutlet internal weak var qrCodeImageView:UIImageView!
    @IBOutlet internal weak var dropDownButton:UIButton!
    
    @IBOutlet internal weak var centerContentHeight:NSLayoutConstraint!
    @IBOutlet var bottomConstraints: [NSLayoutConstraint]!
    @IBOutlet internal weak var viewWidthConstraint:NSLayoutConstraint!
    
    var addresses = Addresses()
    
    var viewModel:CoinsOperationViewModel = CoinsOperationViewModel()
    
    var coinType:CoinType = .emercoin
    
    var dropDown:DropDown?
    let disposeBag = DisposeBag()
    internal var address = ""
    
    override class func storyboardName() -> String {
        return "CoinsOperation"
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title:coinType.fullName())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupDropDownUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amountTextField.textChanged = {(text)in
            self.generateQRCode(at:self.address)
        }
    
        setupDropDown()
        generateQRCode(at:self.address)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateAddressBook()
        updateController()
    }
    
    override func setupUI() {
        super.setupUI()
    
        amountLabel.text = String(format:"%@:",NSLocalizedString("Amount", comment: "")) 
        
        hideStatusBar()
        
        if isIphone5() {
            let value = CGFloat(Constants.Receive.iphone5)
            centerContentHeight.constant -= value
            
            bottomConstraints.forEach({ constraint in
                constraint.constant -= value / 2.0
            })
        }
        
        viewModel.color.subscribe(onNext: { [weak self] color in
            UIView.animate(withDuration: 0.1) {
                self?.coinSignLabel.textColor = color
            }
        }).disposed(by: disposeBag)
        
        viewModel.coinSign.subscribe(onNext: { [weak self] sign in
            self?.coinSignLabel.text = sign
        }).disposed(by: disposeBag)
        
        viewModel.coinType = coinType
    }
    
    internal func updateController() {
        
        if let data = object as? [String : Any] {
            
            guard let address = data["address"] as? String else {
                return
            }
            
            if self.addressLabel != nil {
                
                self.address = address
                self.addressLabel.text = address
                
                guard var amount = data["amount"] as? String else {
                    return
                }
                
                amount = String.dropZeroLast(at: amount)
                amountTextField.text = amount
                
                generateQRCode(at: address)
                
                object = nil
            }
        }
    }
    
    internal func updateAddressBook() {
        addresses.type = viewModel.coinType
        self.setupDataSource()
    }
    
    @IBAction func sendButtonPressed(sender:UIButton) {
       showShareController()
    }
    
    @IBAction func copyButtonPressed(sender:UIButton) {
        
        UIPasteboard.general.string = address
        showCopyView()
    }
    
    private func showShareController() {
        
        let text = address as Any
        let image = qrCodeImageView.image as Any
        
        let activityViewController = UIActivityViewController(activityItems: [text, image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    internal func generateQRCode(at address:String) {

        var amount = amountTextField.text ?? ""
        amount.formattedNumber()
        
        let isValidAmount = viewModel.coinType == .bitcoin ? amount.validBitcoinAmount() : amount.validEmercoinAmount()
        
        let name = viewModel.coinType == .bitcoin ? "bitcoin" : "emercoin"
        var text = ""
        
        if (address.length) > 0 {
            text =  name+":\(address)"
            
            if isValidAmount {
                
                text = text+"?amount=\(amount)"
            }
            
            QRCodeHelper.generateQRCode(at: text, size: qrCodeImageView.frame.size, completion: { (image) in
                self.qrCodeImageView.image = image
            })
        }
    }
}
