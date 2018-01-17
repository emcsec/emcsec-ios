//
//  AddressBookViewModel.swift
//  EmercoinOne
//

import UIKit
import RxSwift
import RxCocoa

class ContactsViewModel {

    let bitColor = Constants.Main.HeaderView.BitcoinColor
    let emerColor = Constants.Main.HeaderView.EmercoinColor
    
    let disposeBag = DisposeBag()
    
    var coinImage = PublishSubject<UIImage>()
    var statusColor: Observable<UIColor>!
    var titleColor:UIColor?
    var addImage:UIImage?
    
    var coinType:CoinType = .bitcoin {
        didSet {
            
            let isBitcoin = coinType == .bitcoin
            
            let imageName = isBitcoin ? Constants.Main.HeaderView.BitcoinImage :
                Constants.Main.HeaderView.EmercoinImage
            
            let addImageName = isBitcoin ? "book_add_bit_icon" : "book_add_emc_icon"
            addImage = UIImage(named: addImageName)

            coinImage.onNext(UIImage(named: imageName)!)
            
        }
    }
    
    init() {
        
        statusColor = coinImage.asObserver()
            .map({ string in
                let isBitcoin = self.coinType == .bitcoin
                let colorHEX = isBitcoin ? Constants.Main.StatusColor.BitcoinColor :
                    Constants.Main.StatusColor.EmercoinColor
                let colorHEX2 = isBitcoin ? self.bitColor : self.emerColor
                self.titleColor = UIColor(hexString: colorHEX2)
                return UIColor(hexString: colorHEX)
            })
    }
}
