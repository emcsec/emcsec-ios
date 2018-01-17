//
//  MainHeaderViewModel.swift
//  EmercoinOne
//

import UIKit
import RxSwift
import RxCocoa

class MainHeaderViewModel {
    
    let bitColor = Constants.Main.HeaderView.BitcoinColor
    let emerColor = Constants.Main.HeaderView.EmercoinColor
    
    let disposeBag = DisposeBag()
    
    private var wallet = AppManager.sharedInstance.wallet
    
    var coinType:CoinType = .emercoin {
        didSet {
            updateUI()
        }
    }
    
    var color = PublishSubject<UIColor>()
    var title = PublishSubject<String>()
    var image = PublishSubject<UIImage>()
    var amount = PublishSubject<String>()
    var courseTitle = PublishSubject<NSAttributedString>()
    
    
    func updateUI() {
        
        let isEmercoin = coinType == .emercoin
        let colorString = isEmercoin ? self.emerColor : self.bitColor
        let color = UIColor.init(hexString: colorString)
        let title = isEmercoin ? wallet.emercoin.name : wallet.bitcoin.name
        let imageName = isEmercoin ? Constants.Main.HeaderView.EmercoinImage :
            Constants.Main.HeaderView.BitcoinImage
        let image = UIImage(named: imageName) ?? UIImage()
        
        let amount = isEmercoin ? wallet.emercoin.stringAmount() : wallet.bitcoin.stringAmount()
        let sign = isEmercoin ? wallet.emercoin.sign : wallet.bitcoin.sign
        let stringAmount = String(format:"%@ %@",amount,sign)
        let courseTitle = isEmercoin ? wallet.emercoin.exchangeAttributedString(color: .white) :
            wallet.bitcoin.exchangeAttributedString(color: .white)
        
        
        self.title.onNext(title ?? "")
        self.color.onNext(color)
        self.image.onNext(image)
        self.amount.onNext(stringAmount)
        self.courseTitle.onNext(courseTitle)
    }
    
    init() {
        
        wallet.completion.subscribe(onNext:{[weak self] state in
            self?.updateUI()
        }).disposed(by: disposeBag)
    }
}
