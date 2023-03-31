//
//  GetDataClass.swift
//  BitcoinBlockChainMinimalist
//
//  Created by 陳囿豪 on 2017/07/11.
//  Copyright © 2017年 yasuoyuhao. All rights reserved.
//

import UIKit


class GetDataClass {
    
    static let updateFailedNSNotification = NSNotification.Name(rawValue: "updateFailedNSNotification")
    
    static func getDataFormURL(url: String , postMethod :String , completion: @escaping (Data?) -> Void ) {
        
        guard let url = URL(string: url) else { return }
        
        var request = URLRequest(url: url)
        
        
        
        request.httpMethod = postMethod
        
        URLSession.shared.dataTask(with: request) { (data, res, err) in
            
            if let err = err {
                print("Failed to fetch API", err)
                NotificationCenter.default.post(name: updateFailedNSNotification, object: nil)
                return
            }
            
            if let data = data {
                completion(data)
            }
            
            }.resume()
        
    }
    
    static func urlHandling(url: String , parameters : Array<Dictionary<String, String>>) -> String {
        
        var urlParameters = url
        
        parameters.forEach { (dictaries) in
            
            dictaries.forEach({ (key, value) in
                urlParameters += key + "=" + value + "&"
            })
        }
        
        return urlParameters
    }
    
    static func handleParametersArray(currencyPair : String, startDate : Double) ->  [Dictionary<String, String>] {
        
        var parametersArray = [Dictionary<String, String>]()
        

        let period = "86400"
        
        parametersArray.append(["command": "returnChartData"])
        parametersArray.append(["currencyPair": currencyPair])
        parametersArray.append(["start": String(describing: startDate)])
        parametersArray.append(["end": "9999999999"])
        parametersArray.append(["period": period])
        
        return parametersArray
    }
    
    
    static func fetchDataFormReturnChartDataAPI(currencyPair : String, startDate: Double, completion: @escaping (NSArray) -> Void ) {
        
        let btcChartDataParameters = handleParametersArray(currencyPair: currencyPair, startDate: startDate)
        let btcChartDatasURL = urlHandling(url: "https://poloniex.com/public?", parameters: btcChartDataParameters)
        let postMethod = "GET"
        
        getDataFormURL(url: btcChartDatasURL, postMethod: postMethod) { (data) in
            
            do {
                guard let data = data else { return }
                
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject as? NSArray
                
                guard let jsonResults = jsonResult else { return }
                completion(jsonResults)
                
            } catch {
                
                print("Failed to jsonResult")
                NotificationCenter.default.post(name: updateFailedNSNotification, object: nil)
                return
            }
        }
    }
    
    static func fetchDataFormReturnTickerAPI(completion: @escaping (NSDictionary) -> Void ) {
        
        let returnTickerURL = "https://poloniex.com/public?command=returnTicker"
        let postMethod = "GET"
        
        getDataFormURL(url: returnTickerURL, postMethod: postMethod) { (data) in
            do {
                
                guard let data = data else { return }
                
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject as? NSDictionary
                
                
                guard let jsonResults = jsonResult else { return }
                completion(jsonResults)
                
            } catch {
                
                print("Failed to jsonResult")
                NotificationCenter.default.post(name: updateFailedNSNotification, object: nil)
                return
            }
        }
        
        
    }
    
    
}










