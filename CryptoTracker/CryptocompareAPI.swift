//
//  CryptocompareAPI.swift
//  CryptoTracker
//
//  Created by Zaizen Kaegyoshi on 9/11/17.
//  Copyright © 2017 zaizencorp. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CryptocompareAPI {
    
    let url = "https://min-api.cryptocompare.com"
    
    func fetchPairFromExchange(pair: String, exchange: String, completion: @escaping (JSON) -> Void) {
        
        
        
    }
    
    func fetchCoinList(_ completion: @escaping (JSON) -> Void) {
        let url = "https://min-api.cryptocompare.com/data/all/coinlist"
        self.request(reqUrl: url, completion)
    }
    func fetchCoinDetails(id: Int, _ completion: @escaping (JSON) -> Void) {
        let url = "https://www.cryptocompare.com/api/data/coinsnapshotfullbyid/?id=\(id)"
        self.request(reqUrl: url, completion)
    }
    
    func request(reqUrl: String, _ completion: @escaping (JSON) -> Void) {
        Alamofire.request(reqUrl).responseJSON(completionHandler: { (response) in
            
            if let value = response.result.value {
                let json = JSON(value)
//                print(json)
                completion(json)
            
            }
            
        })
    }
    func fetchAllExchangesAndPairs(completion: @escaping (JSON) -> Void) {
        
        let reqUrl = "\(url)/data/all/exchanges"
        request(reqUrl: reqUrl, completion)
        
    }
    func fetchPrice(for base: String, and quote: String, inExchange exchange: String, _ completion: @escaping (JSON) -> Void) {

//        https://min-api.cryptocompare.com/data/pricemultifull?fsyms=BTC,ETH&tsyms=USD&e=Coinbase&extraParams=your_app_name
//        let reqUrl = "\(url)/data/generateAvg?fsym=\(base)&tsym=\(quote)&markets=\(exchange)"
        let reqUrl = "\(url)/data/pricemultifull?fsyms=\(base)&tsyms=\(quote)&e=\(exchange)"
        request(reqUrl: reqUrl, completion)
    }
    func fetchExchangesByVolumeFor(base: String, and quote: String, _ completion: @escaping (JSON) -> Void) {
        //        let reqUrl = "\(url)/data/generateAvg?fsym=\(base)&tsym=\(quote)&markets=\(exchange)"
        let reqUrl = "\(url)/data/top/exchanges?fsym=\(base)&tsym=\(quote)&limit=20"
        request(reqUrl: reqUrl, completion)
    }
    func fetchPriceMulti(for bases: [String], and quotes: [String], in exchange: String, _ completion: @escaping (JSON) -> Void) {
        let b: String = bases.reduce("") { (p, s) -> String in
            return p + "\(s.uppercased()),"
        }
        let q: String = quotes.reduce("") { (p, s) -> String in
            return p + "\(s.uppercased()),"
        }
        
        let reqUrl = "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=\(b)&tsyms=\(q)&e=\(exchange)"
        request(reqUrl: reqUrl, completion)
    }
    
    func fetchMinutePrice(of base: String, and quote: String, from exchange: String, _ completion: @escaping (JSON) -> Void) {
        
//        https://min-api.cryptocompare.com/data/histominute?fsym=ETH&tsym=USD&limit=60&aggregate=3&e=Kraken
        let reqUrl = "\(url)/data/histominute?fsym=\(base)&tsym=\(quote)&e=\(exchange)"
        request(reqUrl: reqUrl, completion)
    
        
        
    }
    func fetchCharts(of base: String, and quote: String, from exchange: String, for duration: ShowCoin.Duration, _ completion: @escaping (JSON) -> Void) {
        let urlMap: [ShowCoin.Duration: String] = [
            ShowCoin.Duration.Day : "\(url)/data/histominute?fsym=\(base)&tsym=\(quote)&e=\(exchange)",
            ShowCoin.Duration.Week : "\(url)/data/histohour?fsym=\(base)&tsym=\(quote)&e=\(exchange)&limit=\(7*24)",
            ShowCoin.Duration.Month : "\(url)/data/histohour?fsym=\(base)&tsym=\(quote)&e=\(exchange)&limit=\(30*24)",
            ShowCoin.Duration.Month3 : "\(url)/data/histoday?fsym=\(base)&tsym=\(quote)&e=\(exchange)&limit=\(90)",
            ShowCoin.Duration.Year : "\(url)/data/histoday?fsym=\(base)&tsym=\(quote)&e=\(exchange)&limit=\(365)",
            
        ]
        let reqUrl: String = urlMap[duration]!
        request(reqUrl: reqUrl, completion)
    }
    
    
    
    
    
}
