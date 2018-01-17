//
//  DashboardViewController.swift
//  EmercoinSecureWallet
//

import UIKit
import RxSwift
import RxCocoa

class DashboardViewController: BaseViewController {
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet private weak var mobileLabel:UILabel!

    internal var selectedRows:[IndexPath] = []
    internal var coins:[Any] = []

    let viewModel = DashboardViewModel()
    let disposeBag = DisposeBag()
    
    var isNeedLoadAllData = AppManager.sharedInstance.isNeedLoadAllData
    
    override class func storyboardName() -> String {
        return "Dashboard"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        tabBarObject = TabBarObject(title: Constants.TabTitle.Home,
                                    imageName: Constants.TabImage.Home)
        
        DispatchQueue.global(qos: .background).async {
            APISocketsManager.sharedInstance.initSockets()
            Settings.baseInitUserFee()
        }
    }
    
    override func setupUI() {
        super.setupUI()
        
        mobileLabel?.text = NSLocalizedString("mobile wallet", comment: "").uppercased()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.isNeedLoadAllData {
            self.viewModel.loadAllData()
        } else {
            self.viewModel.loadCourses()
        }
        
        let wallet = viewModel.wallet
        coins = [wallet.emercoin,wallet.bitcoin]
        
        setupTableView()
        setupDashboard()
        setupRefreshControl()
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            pinTouchIDHelperSetup()
        }
    }

    private func load() {
        viewModel.updateWallet()
    }
    
    private func setupDashboard() {
        
        viewModel.walletCompletion.subscribe(onNext: {[weak self] (state) in
            DispatchQueue.main.async {
                if let isLoading = self?.viewModel.isLoading {
                    if !isLoading {
                        self?.tableView.endRefreshing()
                        self?.tableView.reload()
                    }
                }
            }
        }).disposed(by: disposeBag)
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
    
    private func setupTableView() {
        
        selectedRows.append(IndexPath(row: 0, section: 0))
        tableView.hideEmtyCells()
        tableView.allowsSelection = false
    }
}
