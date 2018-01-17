//
//  CoinCourseAPI.swift
//  EmercoinOne
//


import UIKit

class CoinCourseAPI {
    
    var coin:CoinType = .emercoin
    var currency:CurrencyType = .usd
    
    public func startRequest(completion:@escaping (_ data: Any?) -> Void) {
        
        let isEmercoin = coin == .emercoin
        
        var baseUrl = isEmercoin ? Constants.API.EmercoinCourse : Constants.API.BitcoincoinCourse
        baseUrl = baseUrl + currency.description(forApi: true)
        guard let url = URL(string:baseUrl) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession.init(configuration: .default)
        
        var jsonObject:[[String:Any]]?
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                
                let statusCode = httpResponse.statusCode
                
                if statusCode == 200 {
                    
                    jsonObject = self.getJsonObject(data: data!)
                    if jsonObject != nil {
                        
                        let key = "price_" + self.currency.description(forApi: true).lowercased()
                        
                        var price = ""
                        
                        if let value = jsonObject?.first?[key] as? String {
                            price = value
                        }
                        
                        completion(price)
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    private func getJsonObject(data:Data) -> [[String:Any]]? {
        var jsonObject:[[String:Any]] = []
        do {
            jsonObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as! [[String:Any]]
        } catch {
            return nil
        }
        
        return jsonObject
    }
}
