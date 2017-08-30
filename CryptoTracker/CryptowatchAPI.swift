//
//  CryptowatchAPI.swift
//  CryptoTracker
//
//  Created by Zaizen Kaegyoshi on 8/25/17.
//  Copyright © 2017 zaizencorp. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CryptowatchAPI {
    
    var url = "https://api.cryptowat.ch"
    
//    symbol is lowercased
    func fetchExchangesAndPairs(symbol: String, completion: @escaping (JSON) -> Void) {
        let reqUrl = "\(url)/assets/\(symbol)"
        Alamofire.request(reqUrl).responseJSON(completionHandler: { (response) in
            
            if let value = response.result.value {
                let json = JSON(value)
                
                
                completion(json)
                //                print(json)
            }
            
        })
    }
    
    func fetchPairSummary(pair: String, exchange: String, completion: @escaping (JSON) -> Void) {
        let reqUrl = "\(url)/markets/\(exchange)/\(pair)/summary"
        Alamofire.request(reqUrl).responseJSON(completionHandler: { (response) in
            
            if let value = response.result.value {
                let json = JSON(value)
                
                
                completion(json)
                //                print(json)
            }
            
        })
    }
    
}
