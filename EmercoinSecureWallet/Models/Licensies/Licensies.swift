//
//  Licensies.swift
//  EmercoinBasic
//

import UIKit
import ObjectMapper

class Licensies: NSObject {

    var licensies:[License] = []
    
    func load() {
        do {
            if let file = Bundle.main.url(forResource: "licensies", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    if let items = object["items"] {
                        if let licensies = Mapper<License>().mapArray(JSONObject: items) {
                            self.licensies = licensies
                        }
                    }
                } else if let object = json as? [Any] {
                    // json is an array
                    print(object)
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
