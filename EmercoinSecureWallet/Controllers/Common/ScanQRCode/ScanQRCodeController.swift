//
//  ScanQRCodeController.swift
//  EmercoinOne
//

import UIKit
import AVFoundation
import QRCodeReader

class ScanQRCodeController: BaseViewController {
    
    var scanned:((_ data:AnyObject) -> (Void))?

    lazy var reader: QRCodeReader = QRCodeReader()
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            $0.showTorchButton = true
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.loadScanner()
        }
    }
    
    private func loadScanner() {
        
        do {
            if try QRCodeReader.supportsMetadataObjectTypes() {
                readerVC.modalPresentationStyle = .formSheet
                readerVC.modalTransitionStyle = .crossDissolve
                readerVC.delegate               = self
                
                readerVC.completionBlock = { (result: QRCodeReaderResult?) in
                    if let result = result {
                        print("Completion with result: \(result.value) of type \(result.metadataType)")
                    }
                }
                
                present(readerVC, animated: true, completion: nil)
            }
        } catch let error as NSError {
            
            let errorText = NSLocalizedString("Error", comment: "")
            let cancelText = NSLocalizedString("Cancel", comment: "")
            let okText = NSLocalizedString("Ok", comment: "")
            
            switch error.code {
            case -11852:
                let message = NSLocalizedString("This app is not authorized to use Back Camera.", comment: "")
                let settings = NSLocalizedString("Settings", comment: "")
                let alert = UIAlertController(title: errorText, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: settings, style: .default, handler: { (_) in
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                        }
                        self.dismiss(animated: true, completion: nil)
                    }
                }))
                alert.addAction(UIAlertAction(title:cancelText, style: .cancel, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                }))
                present(alert, animated: true, completion: nil)
            case -11814:
                let message = NSLocalizedString("Reader not supported by the current device", comment: "")
                let alert = UIAlertController(title: errorText, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: okText, style: .cancel, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                }))
                present(alert, animated: true, completion: nil)
            default:()
            }
        }
    }
}

extension ScanQRCodeController : QRCodeReaderViewControllerDelegate {
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        dismiss(animated: true) { [weak self] in
    
            QRCodeHelper.parseScanedText(result: result.value, completion: { data, success in
                
                let incorrectQRCode = NSLocalizedString("QR-Code is incorrect", comment: "")
                let okText = NSLocalizedString("Ok", comment: "")
                
                let alert = UIAlertController(
                    title: "",
                    message: incorrectQRCode,
                    preferredStyle: .alert
                )
                // alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                if !success! {
                    alert.addAction(UIAlertAction(title: okText, style: .cancel, handler: { (action) in
                        self?.dismiss(animated: true, completion: nil)
                    }))
                    self?.present(alert, animated: true, completion: nil)
                } else {
                    self?.scanned?(data!)
                    self?.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        print("Switching capturing to: \(newCaptureDevice.device.localizedName)")
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
        dismiss(animated: true) { 
            self.parent?.dismiss(animated: true, completion: nil)
        }
    }
}
