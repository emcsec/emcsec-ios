//
//  DashboardCell.swift
//  EmercoinSecureWallet
//

import UIKit

class DashboardCell: BaseTableViewCell {
    
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var arrowImageView:UIImageView!
    @IBOutlet weak var iconImageView:UIImageView!
    @IBOutlet weak var overlayView:UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel?.text = NSLocalizedString("My Balance", comment: "")
    }
    
    var views:[DashboardBalanceView] = []
    
    var pressed: ((_ type:CoinType) -> (Void))?
    
    private func addClosureAt(moneyView:DashboardBalanceView) {
        moneyView.pressed = pressed
    }
    
    override func updateUI() {
        
        if !isExpanded {
            return
        }
        
        if let coins = object as? [Coin] {
            
            if views.count == 0 {
                
                var point = CGPoint(x: 0, y: Constants.CellHeights.DashboardCell.Collapsed)
                
                for coin in coins {
                    
                    if views.count > 0 {
                        let separator = UIView(frame:frame)
                        separator.frame.size.height = 1.0
                        separator.frame.origin.y = point.y
                        separator.backgroundColor = .lightGray
                        point.y += 1
                        addSubview(separator)
                    }
                    
                    let view:DashboardBalanceView = loadViewFromXib(name: "Dashboard", index: 0, frame: .zero) as! DashboardBalanceView
                    var newFrame = frame
                    newFrame.origin = point
                    newFrame.size.height = CGFloat(Constants.CellHeights.DashboardCell.MoneyView)
                    view.coin = coin
                    view.frame = newFrame
                    addSubview(view)
                    point.y += newFrame.height
                    
                    views.append(view)
                    addClosureAt(moneyView: view)
                }
            } else {
                for i in 0...views.count - 1  {
                    views[i].coin = coins[i]
                }
            }
        }
        
        updateCellHeader()
    }
    
    private func updateCellHeader() {
        
        let titleColor:UIColor = (isExpanded) ? UIColor(hexString: "#9C73B1"): .white
        titleLabel.textColor = titleColor
        
        let iconImage = (isExpanded) ? "wallet_icon_color" : "wallet_icon"
        iconImageView.image = UIImage.init(named: iconImage)
        
        let arrowImage = (isExpanded) ? "arrow_col_icon" : "arrow_exp_icon"
        arrowImageView.image = UIImage.init(named: arrowImage)
        
        overlayView.isHidden = !isExpanded
    }
    
    @IBAction func pressedButton(sender:UIButton) {
        
        isExpanded = !isExpanded
        updateCellHeader()
        if pressedCell != nil {
            pressedCell!(indexPath!)
        }
    }}
