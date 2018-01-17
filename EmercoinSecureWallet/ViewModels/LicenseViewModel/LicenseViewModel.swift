//
//  LicenseViewModel.swift
//  EmercoinBasic
//

import UIKit

class LicenseViewModel {

    var name = ""
    var text = ""
    var url = ""
    
    init(license:License) {
        name = license.name
        text = license.text
        url = license.url
    }
}
