//
//  License.swift
//  EmercoinBasic
//

import UIKit
import ObjectMapper

class License: NSObject, Mappable {

    var name = ""
    var text = ""
    var url = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        text <- map["text"]
        url <- map["url"]
    }
}
