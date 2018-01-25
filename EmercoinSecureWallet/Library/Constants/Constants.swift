//
//  Constants.swift
//  EmercoinOne
//

import Foundation

import UIKit

struct Constants {
    
    static let PinLength = 6
    
    struct API {
        
        static let EmercoinHost = "emcx.emercoin.net"
        static let BitcoinHost = "btcx.emercoin.net"
        static let BitcoinPort:Int32 = 50001
        static let EmercoinPort:Int32 = 9110
        static let Balances = "blockchain.address.get_balance"
        static let HistoryTransactions = "blockchain.address.get_history"
        static let HistoryTransactionRaw = "blockchain.transaction.get"
        static let HistoryTransactionBlockHeader = "blockchain.block.get_header"
        static let UnspentOutputs = "blockchain.address.listunspent"
        static let SendTransaction = "blockchain.transaction.broadcast"

        static let EmercoinCourse = "https://api.coinmarketcap.com/v1/ticker/emercoin/?convert="
        static let BitcoincoinCourse = "https://api.coinmarketcap.com/v1/ticker/bitcoin/?convert="
    }
    
    static let userRecommendedFee = 0.00148372
    
    struct Names {
        static let Prefixes = ["dns","ssh","gpg","kx","ssl","bls","tts","swift","dpo","magnet","enum"]
    }
    
    struct Images {
        static let EmercoinIcon = "emer_icon_1"
        static let BitcoinIcon = "bit_icon_1"
    }
    
    struct Permissions {
        static let PrintDeinit = true
        static let NeedAuth = true
        static let JsonBody = true
    }
    
    struct CellHeights {
        struct DashboardCell {
            static let MoneyView = 95.0
            static let Collapsed = 70.0
        }
    }
    
    struct Colors {
        
        struct ContactCell {
            static let Edit = "d9743c"
            static let Delete = "da3975"
        }
        
        struct NewAddress {
            static let Bitcoin = "#F8C7A3"
            static let Emercoin = "#A3D8C7"
        }
        
        struct Coins {
            static let Bitcoin = "#fb8335"
            static let Emercoin = "#8C5DA3"
        }
        
        struct CancelButton {
            static let Bitcoin = "4D4D4D"
            static let Emercoin = "DA4079"
        }
        
        struct Status {
            static let Bitcoin = "#8a481d"
            static let Emercoin = "#684979"
            static let Base = "#684979"
            static let Menu = "#3d3d3d"
        }
        
        struct TabBar {
            static let Tint = "#8C5DA3"
        }
        
        struct NavBar {
            static let Tint = "#2B7582"
            static let BarTint = "#8C5DA3"
        }
    }
    
    struct CoinsOperation {
        
        static let RecipientAddress = NSLocalizedString("Send Coins", comment: "")
        static let Send = NSLocalizedString("Send Coins", comment: "")
        static let Addresses = NSLocalizedString("My Addresses", comment: "")
        static let Receive = NSLocalizedString("Receive Coins", comment: "")
        static let History = NSLocalizedString("History", comment: "")
        static let Operations = NSLocalizedString("Operations", comment: "")
    }
    
    struct Receive {
        static let iphone5 = 40.0
    }
    
    struct Main {
        struct HeaderView {
            static let BitcoinColor = "#fb8335"
            static let EmercoinColor = "#8C5DA3"
            static let BitcoinImage = "base_bit_icon"
            static let EmercoinImage = "base_emer_icon"
        }
        struct StatusColor {
            static let BitcoinColor = "#8a481d"
            static let EmercoinColor = "#684979"
        }
    }
    
    struct Constraints {
        struct Login {
            struct Top {
                static let iphone5 = 20.0
            }
        }
    }
    
    struct Menu {
        
        struct Addresses {
            static let Title = NSLocalizedString("My Addresses", comment: "")
            static let Image = "menu_addresses_icon"
        }
        
        struct History {
            static let Title = NSLocalizedString("History", comment: "")
            static let Image = "menu_history_icon"
        }
        
        struct Settings {
            static let Title = NSLocalizedString("Settings", comment: "")
            static let Image = "menu_settings_icon"
        }
        
        struct Licensies {
            static let Title = NSLocalizedString("Licenses", comment: "")
            static let Image = "menu_legal_icon"
        }
        
        struct About {
            static let Title = NSLocalizedString("About", comment: "")
            static let Image = "menu_about_icon"
        }
        
        struct Profile {
            static let Title = NSLocalizedString("My Profile", comment: "")
            static let Image = "menu_profile_icon"
        }
        
        struct Exit {
            static let Title = NSLocalizedString("Close the wallet", comment: "")
            static let Image = "menu_exit_icon"
        }
        
    }
    
    struct TabTitle {
        static let Home = NSLocalizedString("Dashboard", comment: "")
        static let Send = NSLocalizedString("Send", comment: "")
        static let Receive = NSLocalizedString("Receive", comment: "")
        static let More = NSLocalizedString("More", comment: "")
        static let Names = NSLocalizedString("Names", comment: "")
        static let History = NSLocalizedString("History", comment: "")
    }
    
    struct TabImage {
        static let Home = "tab_home_icon"
        static let Send = "tab_send_icon"
        static let Receive = "tab_get_icon"
        static let More = "tab_more_icon"
        static let Names = "tab_blockchain_icon"
        static let History = "tab_history_icon"
    }
}
