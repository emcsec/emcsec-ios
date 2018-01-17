//
//  ContactsViewController.swift
//  EmercoinSecureWallet
//

import UIKit
import RxSwift
import SwipeCellKit

class ContactsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {

    @IBOutlet internal weak var headerView:ContactsHeaderView!
    @IBOutlet internal weak var operationLabel:UILabel!
    @IBOutlet internal weak var menuButton:UIButton!
    @IBOutlet internal weak var backButton:UIButton!
    @IBOutlet internal weak var addButton:UIButton!
    @IBOutlet internal weak var noAddressesView:UIView!
    @IBOutlet internal weak var noAddressesLabel:UILabel!
    
    @IBOutlet internal weak var tableView:UITableView!
    
    var selectedAddress:((_ text:String) -> (Void))?
    
    var contacts = Contacts()
    
    let viewModel = ContactsViewModel()
    let disposeBag = DisposeBag()
    
    var coinType:CoinType = .bitcoin {
        didSet {
            viewModel.coinType = coinType
        }
    }
    
    var side:Side = .left
    
    override class func storyboardName() -> String {
        return "Contacts"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.baseSetup()
        viewModel.coinType = coinType
        contacts.type = coinType
        updateUI()
    }
    
    override func setupUI() {
        super.setupUI()
        
        let title = NSLocalizedString("Address book", comment: "").uppercased().replacingOccurrences(of: " ", with: "\n")
        let operationText = NSLocalizedString("List of recipients", comment: "")
        let noContactsText = NSLocalizedString("There are no addresses", comment: "")
        
        noAddressesLabel.text = noContactsText
        operationLabel.text = operationText
        headerView.titleLabel.text = title
        
        viewModel.coinImage.bind(to: headerView.coinImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.statusColor.subscribe(onNext: { [weak self] color in
            UIView.animate(withDuration: 0.1) {
                self?.operationLabel.textColor = self?.viewModel.titleColor
                self?.headerView.backgroundColor = self?.viewModel.titleColor
                guard let statusView = self?.statusBarView else {
                    return
                }
                statusView.backgroundColor = color
                
                self?.addButton.setImage(self?.viewModel.addImage, for: .normal)
            }
        }).disposed(by: disposeBag)
        
    }
    
    internal func updateUI() {
        
        noAddressesView.isHidden = contacts.contacts.count != 0
    }
    
    @IBAction func addButtonPressed(sender:UIButton) {
        
        showAddContactView()
    }
    
    private func updateTable()  {
        self.updateUI()
        self.tableView.reload()
    }
    
    private func showAddContactView() {
        
        let modalVC = loadController(at: "BaseModalViewController", storyboard:"Main") as! BaseModalViewController
        
        let addContactView = loadViewFromXib(name: "Contacts", index: 1,
                                             frame: self.parent!.view.frame) as! AddContactView
        addContactView.coinType = coinType
        addContactView.add = ({(name, address) in
            
            let contact = Contact(value:["name":name, "address": address, "type":self.coinType.fullName()])
            self.contacts.add(contact: contact)
            
            self.updateTable()
        })
        modalVC.modalView = addContactView
        present(modalVC, animated: true, completion: nil)
        //self.parent?.view.addSubview(addContactView)
    }
}
