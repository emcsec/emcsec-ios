//
//  TabBarObject.swift
//  EmercoinOne
//

import UIKit

protocol TabBarObjectInfo {
    
    var tabBarObject:TabBarObject? {get set}
}

class TabBarObject {
    
    var title:String
    var imageName:String
    
    init(title:String, imageName:String) {
        self.title = title
        self.imageName = imageName
    }
}
