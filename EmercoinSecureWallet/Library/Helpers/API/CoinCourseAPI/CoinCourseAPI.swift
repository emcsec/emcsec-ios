//
//  CoinCourseAPI.swift
//  EmercoinOne
//


import UIKit

class CoinCourseAPI {
    
    var coin:CoinType = .emercoin
    var currency:CurrencyType = .usd
    
    var method:String {
        return ""
    }
    
    public func startRequest(completion:@escaping (_ price: Double) -> Void) {
        
        let isEmercoin = coin == .emercoin
        
        var host = Constants.API.CoinmarketcapTicker
        let id = isEmercoin ? Constants.API.CoinmarketcapEmercoinId : Constants.API.CoinmarketcapBitcoinId
        let currency = self.currency.description(forApi: true)
        host = host.replacingOccurrences(of: "id", with: id)
        host = host.replacingOccurrences(of: "currency", with: currency)
        
//        var baseUrl = isEmercoin ? Constants.API.EmercoinCourse : Constants.API.BitcoincoinCourse
//        baseUrl = baseUrl + currency.description(forApi: true)
        guard let url = URL(string:host) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession.init(configuration: .default)
        
        var jsonObject:[String:Any]?
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                
                let statusCode = httpResponse.statusCode
                
                if statusCode == 200 {
                    
                    jsonObject = self.getJsonObject(data: data!)
                    if jsonObject != nil {
                        if let criptoCoin = (jsonObject!["data"] as? NSArray)?.firstObject as? [String:Any] {
                            if let quotes = criptoCoin["quotes"] as? [String:Any] {
                                let key = self.currency.description(forApi: true)
                                if let currency = (quotes[key] as? [String:Any]){
                                    if let value = currency["price"] as? Double {
                                        completion(value)
                                    }
                                }
                            }
                        }
                        
//                        let key = "price_" + self.currency.description(forApi: true).lowercased()
//
//                        var price = ""
//
//                        if let value = jsonObject?.first?[key] as? String {
//                            price = value
//                        }
//
//                        completion(price)
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    private func getJsonObject(data:Data) -> [String:Any]? {
        var jsonObject:[String:Any]?
        do {
            jsonObject = try (JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [String:Any])
        } catch {
            return nil
        }
        
        return jsonObject
    }
}
