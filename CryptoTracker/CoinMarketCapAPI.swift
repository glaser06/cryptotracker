//
//  CoinMarketCapAPI.swift
//  CryptoTracker
//
//  Created by Zaizen Kaegyoshi on 8/23/17.
//  Copyright © 2017 zaizencorp. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CoinMarketCapAPI {
    
    var url = "https://api.coinmarketcap.com/v1/ticker/?limit=200"
    
    func getCoinInfo(completion: @escaping (JSON) -> Void) {
        Alamofire.request(url).responseJSON(completionHandler: { (response) in

            if let value = response.result.value {
                let json = JSON(value)
                
                completion(json)
//                print(json)
            }
            
        })
    }
    
}
