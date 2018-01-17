//
//  CoinsOpeartionHeaderView.swift
//  EmercoinOne
//

import UIKit
import RxSwift
import RxCocoa

class MainHeaderView: UIView {

    @IBInspectable var changeTitle:Bool = true
    
    @IBOutlet  weak var coinImageView:UIImageView!
    @IBOutlet  weak var bitcoinImageView:UIImageView!
    @IBOutlet  weak var coinTitleLabel:UILabel!
    @IBOutlet  weak var coinCourseLabel:UILabel!
    @IBOutlet  weak var coinAmountLabel:UILabel!

    let disposeBag = DisposeBag()
    
    let viewModel = MainHeaderViewModel()
    
    var coinType:CoinType = .emercoin {
        didSet {
            viewModel.coinType = coinType
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
        viewModel.updateUI()
    }
    
    private func setupView() {
        
        viewModel.color.subscribe(onNext:{[weak self] color in
            self?.backgroundColor = color
        }).disposed(by: disposeBag)
        
        if changeTitle {
            viewModel.title.bind(to: coinTitleLabel.rx.text)
                .disposed(by: disposeBag)
        }
        
        viewModel.image.bind(to: coinImageView.rx.image)
            .disposed(by: disposeBag)
        viewModel.amount.bind(to: coinAmountLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.courseTitle.bind(to: coinCourseLabel.rx.attributedText)
            .disposed(by: disposeBag)
    }
}
