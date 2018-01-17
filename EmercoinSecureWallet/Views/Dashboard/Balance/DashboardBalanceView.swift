//
//  DashboardBalanceView.swift
//  EmercoinBasic
//

import UIKit

class DashboardBalanceView: UIView {

    @IBOutlet weak var iconImageView:UIImageView!
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var countLabel:UILabel!
    @IBOutlet weak var exchangeLabel:UILabel!
    
    var pressed:((_ type:CoinType) -> (Void))?
    
    var coin:Coin? {
        didSet{
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let button = UIButton()
        button.addTarget(self, action: #selector(DashboardBalanceView.buttonPressed), for: .touchUpInside)
        addSubview(button)
        
        NSLayoutConstraint(item: button, attribute: .leading, relatedBy: .equal, toItem: self,
                           attribute: .leading, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: self,
                           attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: self,
                           attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: button, attribute: .trailing, relatedBy: .equal, toItem: self,
                           attribute: .trailing, multiplier: 1.0, constant: 0.0).isActive = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func updateUI() {
        
        guard let coin = self.coin else {
            return
        }
        
        nameLabel.text = coin.name
        nameLabel.textColor = UIColor(hexString: coin.color!)
        countLabel.text = String(format:"%@ %@",coin.stringAmount(),coin.sign)
        
        if let image = UIImage(named: coin.image!) {
            iconImageView.image = image
            
        }
        
        exchangeLabel.attributedText = coin.exchangeAttributedString()
    }
    
    @objc func buttonPressed() {
        
        guard let type = self.coin?.type else {
            return
        }
        
        if pressed != nil {
            pressed!(type)
        }
    }
}
