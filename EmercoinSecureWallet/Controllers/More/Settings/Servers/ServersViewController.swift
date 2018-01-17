//
//  ServersViewController.swift
//  EmercoinSecureWallet
//

import UIKit

class ServersViewController: BaseViewController {
    
    @IBOutlet internal weak var titleLabel:UILabel!
    @IBOutlet internal weak var bitcoinLabel:UILabel!
    @IBOutlet internal weak var emercoineLabel:UILabel!
    
    @IBOutlet internal weak var bitcoinHostLabeL:UILabel!
    @IBOutlet internal weak var bitcoinPortLabeL:UILabel!
    @IBOutlet internal weak var emercoinHostLabeL:UILabel!
    @IBOutlet internal weak var emercoinPortLabeL:UILabel!

    private var emercoinServer:Server?
    private var bitcoinServer:Server?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let emercoinServer = Settings.server(at: .emercoin),
            let bitcoinServer = Settings.server(at: .bitcoin)  else {
                return
        }
        
        self.emercoinServer = emercoinServer
        self.bitcoinServer = bitcoinServer
        
        updateUI()
    }
    
    override func setupUI() {
        super.setupUI()
        
        titleLabel?.text = NSLocalizedString("Servers", comment: "").uppercased()
        bitcoinLabel?.text = String(format:"%@ %@", NSLocalizedString("The server for", comment: ""), CoinType.bitcoin.fullName())
        emercoineLabel?.text = String(format:"%@ %@", NSLocalizedString("The server for", comment: ""), CoinType.emercoin.fullName())
    }
    
    private func updateUI() {
    
        guard let emercoinServer = self.emercoinServer,
            let bitcoinServer = self.bitcoinServer  else {
                return
        }
    
        updateUI(at: emercoinServer)
        updateUI(at: bitcoinServer)
    }
    
    private func updateUI(at server:Server) {
        
        let host = String(format:"%@: %@",NSLocalizedString("Host", comment: ""), server.host)
        let port = String(format:"%@: %i",NSLocalizedString("Port", comment: ""), server.port)
        
        if server.type == "Emercoin" {
            emercoinHostLabeL.text = host
            emercoinPortLabeL.text = port
        } else {
            bitcoinHostLabeL.text = host
            bitcoinPortLabeL.text = port
        }
    }
    
    override class func storyboardName() -> String {
        return "Settings"
    }
    
    private func reconnectSockets() {
        
        DispatchQueue.global(qos: .background).async {
            APISocketsManager.sharedInstance.initSockets()
            APISocketsManager.sharedInstance.connectSockets { (error) in
                if let error = error {
                    DispatchQueue.main.async {
                        showErroViewAlert(error: error)
                    }
                }
            }
        }
    }

    @IBAction func editButtonPressed(sender:UIButton) {
        
        let type:CoinType = sender.tag == 0 ? .emercoin : .bitcoin
        
        
        if let server = type == .bitcoin ? self.bitcoinServer : self.emercoinServer {
            
            let modalVC = loadController(at: "BaseModalViewController", storyboard:"Main") as! BaseModalViewController
            
            let view = loadViewFromXib(name: "Server", index: 0) as! ServerEditView
            view.frame = self.view.frame
            view.type = type
            view.update(host: server.host, port: server.port, ssl:server.ssl)
            
            view.edit = {host, port, ssl in
                Settings.updateServer(host: host, port: port, ssl: ssl, type: type)
                self.updateUI()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.reconnectSockets()
                }
            }
            modalVC.modalView = view
            present(modalVC, animated: true, completion: nil)
            //self.view.addSubview(view)
        }
    }
}
