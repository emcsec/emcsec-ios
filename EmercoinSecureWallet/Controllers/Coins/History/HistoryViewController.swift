//
//  HistoryViewController.swift
//  EmercoinOne
//

import UIKit
import RxSwift
import RxCocoa

class HistoryViewController: BaseViewController, IndicatorInfoProvider {
    
    @IBOutlet internal weak var tableView:UITableView!
    @IBOutlet internal weak var noTransactionsLabel:UILabel!
    @IBOutlet internal weak var footerView:UIView!
    
    var coinType:CoinType = .emercoin
    
    var history = History()
    
    internal var selectedIndexPath:IndexPath?
    
    let disposeBag = DisposeBag()
    
    internal var isLoadingWithOffset = false
    internal var loadingCellIndexPath:IndexPath?
    
    override class func storyboardName() -> String {
        return "CoinsOperation"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        history.type = coinType
        
        tableView.baseSetup()
        setupHistory()
        updateUI()
        setupRefreshControl()
    }
    
    override func setupUI() {
        super.setupUI()
        hideStatusBar()
        
        noTransactionsLabel?.text = NSLocalizedString("There is no any transaction", comment: "")
    }
    
    private func load() {
        history.load()
    }
    
    private func updateUI() {
        noTransactionsLabel.isHidden = history.totalCount() > 0
    }
    
    private func setupRefreshControl() {
        
        let refresh = UIRefreshControl()
        refresh.tintColor = .clear
        refresh.addTarget(self, action: #selector(self.handleRefresh(sender:)), for: .valueChanged)
        tableView.refreshControl = refresh
    }
    
    @objc internal func handleRefresh(sender:UIRefreshControl) {
        load()
        self.tableView.endRefreshing()
    }
    
    private func setupHistory() {
        
        history.completion.subscribe(onNext:{ [weak self] success in
            DispatchQueue.main.async(execute: {
                self?.tableView.endRefreshing()
                if success {
                    self?.updateUI()
                    self?.tableView.reload()
                    AppManager.sharedInstance.wallet.update()
                }
            })
        }).disposed(by: disposeBag)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: coinType.fullName())
    }
    
    internal func showTransactionDetailView(at viewModel:HistoryTransactionViewModel) {
        
        let transactionDetailView = loadViewFromXib(name: "History", index: 0,
                                                frame: self.parent?.parent?.view.frame) as! HistoryTransactionDetailView
        transactionDetailView.coinType = coinType
        transactionDetailView.viewModel = viewModel
        
        transactionDetailView.repeatTransaction = {[weak self] in
            self?.repeatTransaction()
        }
        
        self.parent?.parent?.view.addSubview(transactionDetailView)

    }
    
    private func repeatTransaction() {
        
        if let indexPath = selectedIndexPath {
            
            let item = itemAt(indexPath: indexPath)
            
            var data = [String:Any]()
            data["address"] = item.address as AnyObject
            data["amount"] = String.coinFormat(at: abs(item.standartAmount())) as AnyObject
            data["coin"] = coinType
            
            selectedIndexPath = nil
            
            let tabBar = Router.sharedInstance.tabBar
            
            let type:CoinsOperation = item.direction() != .incoming ? .recipientAddress : .receive
            
            tabBar?.showController(at: data as AnyObject, type: type)
        }
    }
}
