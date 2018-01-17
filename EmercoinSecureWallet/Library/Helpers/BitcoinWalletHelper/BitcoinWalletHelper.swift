 //
//  BitcoinWalletHelper.swift
//  EmercoinSecureWallet
//

import UIKit

class BitcoinWalletHelper: NSObject {

    private static let addressesCount = 5
    
    class func generateAddresses(at seed:String, completion:@escaping (_ data: [Address]?, _ success:Bool) -> Void) {

        guard let seed = WSSeedMakeNow(seed) else {
            completion(nil,false)
            return
        }
        
        guard let btcAddresses = addresses(at: seed, type: .bitcoin), let emcAddresses = addresses(at: seed, type: .emercoin) else {
            completion(nil,false)
            return
        }
        completion(btcAddresses + emcAddresses, true)
    }
    
    class private func addresses(at seed:WSSeed, type:CoinType) -> [Address]? {
        
        var addressesData:[Address] = []
        let networkType:WSNetworkType = type == .bitcoin ? WSNetworkTypeMain : WSNetworkTypeEmercoin
        
        guard let param = WSParametersForNetworkType(networkType),
            let wallet = WSHDWallet(parameters: param, seed: seed, chainsPath: "m", gapLimit: UInt(addressesCount))  else {
            return nil
        }
        
        if let addresses = Array(wallet.allReceiveAddresses()) as? [WSAddress] {
            addressesData.append(contentsOf: addressesFor(at: addresses, wallet: wallet, param: param, type: type, isChange: false))
        }
        
        if let addresses = Array(wallet.allChangeAddresses()) as? [WSAddress] {
            addressesData.append(contentsOf: addressesFor(at: addresses, wallet: wallet, param: param, type: type, isChange: true))
        }
        return (addressesData.count > 0) ? addressesData : nil
    }
    
    private class func addressesFor(at addresses:[WSAddress], wallet:WSWallet, param:WSParameters, type:CoinType, isChange:Bool = false) -> [Address] {
        
        var addressesData:[Address] = []
        
        for address in addresses {
            let addressObject = Address()
            addressObject.pubAddress = address.description
            addressObject.type = type.fullName()
            addressObject.isUsingForChange = isChange
            if let key = wallet.extendedPrivateKey(for: address).privateKey() {
                addressObject.privKey = key.wif(with: param)
            }
            addressesData.append(addressObject)
            
            if let index = addresses.index(of: address) {
                if index == 4 && isChange {
                    break
                }
                
                if index == 0 && isChange {
                    addressObject.isDefaultForChange = true
                }
            }
        }
        
        return addressesData
    }
}
