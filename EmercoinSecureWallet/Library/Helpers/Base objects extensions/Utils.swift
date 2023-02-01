//
//  Utils.swift
//  Emercoin One
//

import UIKit
import DeviceKit
//import CommonCrypto
import RealmSwift

public func RootViewController() -> UIViewController? {
    return UIApplication.shared.delegate?.window??.rootViewController
}

public func showOperationView(state:Bool) {
    let aHelper = AppManager.sharedInstance.alertsHelper
    if state {aHelper.showOperationView()} else {aHelper.hideOperationView()}
}

public func showProgressView(state:Bool) {
    let aHelper = AppManager.sharedInstance.alertsHelper
    if state {aHelper.showProgressView()} else {aHelper.hideProgressView()}
}

public func updateProgressView(at object:Any) {
    let aHelper = AppManager.sharedInstance.alertsHelper
    aHelper.updateProgressView(at: object)
}

public func showSuccessOperationView(completion:(() -> Void)? = nil) {
    let aHelper = AppManager.sharedInstance.alertsHelper
    aHelper.showSuccessOperationView(completion: completion)
}

public func showErroAlert(error:NSError) {
    let aHelper = AppManager.sharedInstance.alertsHelper
    aHelper.showErrorAlert(at: error)
}

public func showErroViewAlert(error:NSError) {
    let aHelper = AppManager.sharedInstance.alertsHelper
    aHelper.showErrorViewAlert(at: error)
}

public func showCopyView(at view:UIView? = nil) {
    
    let copyView = loadViewFromXib(name: "Operations", index: 3,
                                          frame: nil)
    copyView.alpha = 0;
    
    if let rootView = view != nil ? view : RootViewController()?.view {
        copyView.center = rootView.center
        rootView.addSubview(copyView)
        
        UIView.animate(withDuration: 0.3) {
            copyView.alpha = 0.7
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 0.3, animations: {
                copyView.alpha = 0.0
            }, completion: { (state) in
                copyView.removeFromSuperview()
            })
        }
    }
}

public func loadViewFromXib(name:String, index:Int, frame:CGRect? = nil) -> UIView {
    let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)![index] as! UIView
    
    if frame != nil {
        view.frame = frame!
    }
    return view
}

public func loadController(at name:String, storyboard:String) -> UIViewController {
    let sb = UIStoryboard.init(name: storyboard, bundle: nil)
    return sb.instantiateViewController(withIdentifier: name)
}

public func isIphone5() -> Bool {
    
    var result:Bool! = false
    
    if screenSize().height == 568 {
        result = true
    }
    
    return result
}

internal func screenSize() -> CGRect {
    return UIScreen.main.bounds
}

public func deviceInfo() -> String {
    let device = Device()
    let version = device.systemVersion
    let name = device.isSimulator ? device.model : device.description
    return String(format:"iOS %@ %@",version,name)
}

public func deviceUUID() -> String {
    return UIDevice.current.identifierForVendor!.uuidString
}

public func showInternetActivity(at state:Bool) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = state
}

public func pinTouchIDHelperSetup() {
    Router.sharedInstance.tabBar?.showPinView()
}

public func userInteraction(at enable:Bool) {
    if enable {
        UIApplication.shared.endIgnoringInteractionEvents()
    } else {
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
}

public func bundleVersion() -> String {
    
    var version = "1"
    
    if let versionMain = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
        version = versionMain
    }
    
    return version
}

public func buildVersion() -> String {
    
    var version = "1"
    
    if let versionMain = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
        version = versionMain
    }
    
    return version
}

public func stringFromHttpParameters(at param:[String:Any]) -> String {
    
        let array = Array(param.keys.map{ String(describing: $0) })
        let sortedKeys = array.sorted(by: {$0 < $1})
    
        let parameterArray = sortedKeys.map { (key) -> String in
            let percentEscapedKey = (key).addingPercentEncodingForURLQueryValue()!
            let value = "\(param[key] ?? "")"
            let percentEscapedValue = value.addingPercentEncodingForURLQueryValue()!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        
        }

        return parameterArray.joined(separator: "&")
}

public func uniqueElementsFrom(array: [String]) -> [String] {
    var set = Set<String>()
    let result = array.filter {
        guard !set.contains($0) else {
            return false
        }
        set.insert($0)
        return true
    }
    return result
}

func encodeStringToBase64(string:String) -> String? {
    
    let data = string.data(using: String.Encoding.utf8)
    let string64 = data?.base64EncodedString(options:.endLineWithLineFeed)
    return string64
}

func decodeBase64ToString(base64 : String) -> String? {
    
    let data = Data(base64Encoded: base64, options: NSData.Base64DecodingOptions(rawValue: 0))!
    let string = String.init(data: data, encoding: String.Encoding.utf8)
    return string
}

func md5(string: String) -> String {

    let count = Int(CC_MD5_DIGEST_LENGTH)
    
    let messageData = string.data(using:.utf8)!
    var digestData = Data(count: count)
    
    _ = digestData.withUnsafeMutableBytes {digestBytes in
        messageData.withUnsafeBytes {messageBytes in
            CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
        }
    }
    var digestHex = ""
    for index in 0..<count {
        digestHex += String(format: "%02x", digestData[index])
    }
    return digestHex
}

public func showTabBar(at enable:Bool) {
    Router.sharedInstance.tabBar?.tabBar.isHidden = !enable
}

public func isShowingPinView(at state:Bool) {
    Router.sharedInstance.tabBar?.isShowingPinView = state
}

public func realmDBLocation() -> String {
    
    return Realm.Configuration.defaultConfiguration.fileURL?.absoluteString ?? ""
}

