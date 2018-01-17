//
//  MenuItem.swift
//  EmercoinOne
//

import UIKit

class MenuItem {
    
    var title:String
    var image:String
    var subTitles:[String] = []

    
    init(title:String, image:String) {
        self.title = title
        self.image = image
    }
}
