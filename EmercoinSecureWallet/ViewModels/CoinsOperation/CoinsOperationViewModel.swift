//
//  CoinsOperationViewModel.swift
//  EmercoinOne
//


import UIKit
import RxSwift
import RxCocoa

class CoinsOperationViewModel {
    
    let bitColor = Constants.Main.HeaderView.BitcoinColor
    let emerColor = Constants.Main.HeaderView.EmercoinColor
    
    let disposeBag = DisposeBag()
    var wallet = AppManager.sharedInstance.wallet
    
    var addButtonImage = PublishSubject<UIImage>()
    var coinSign = PublishSubject<String>()
    var statusColor = PublishSubject<UIColor>()
    var color = PublishSubject<UIColor>()
    var colorString = PublishSubject<String>()
    var exchangeRate = PublishSubject<String>()
    var getCoins = PublishSubject<String>()
    
    var coinType:CoinType = .bitcoin {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        
        let isBitcoin = coinType == .bitcoin
        let coinSign = isBitcoin ? wallet.bitcoin.sign : wallet.emercoin.sign
        let addImageName = isBitcoin ? "book_add_bit_icon" : "book_add_emc_icon"
        let addButtonImage = UIImage(named: addImageName) ?? UIImage()
        let statusColorString = isBitcoin ? Constants.Main.StatusColor.BitcoinColor :
            Constants.Main.StatusColor.EmercoinColor
        let statusColor = UIColor(hexString: statusColorString)
        let colorString = isBitcoin ? self.bitColor : self.emerColor
        let color = UIColor(hexString: colorString)
        self.color.onNext(color)
        self.colorString.onNext(colorString)
        self.statusColor.onNext(statusColor)
        self.coinSign.onNext(coinSign)
        self.addButtonImage.onNext(addButtonImage)
    }
}
