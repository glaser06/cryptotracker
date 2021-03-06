//
//  CoinWorker.swift
//  CryptoTracker
//
//  Created by Zaizen Kaegyoshi on 8/25/17.
//  Copyright (c) 2017 zaizencorp. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import SwiftyJSON

class CoinWorker
{
    let coinService: CryptowatchAPI = CryptowatchAPI()
    let bigService = CryptocompareAPI()
    
    
//    func fetchExchanges(coin: Coin, completion: @escaping (Coin) -> Void, error: @escaping () -> Void) {
//        
//        coinService.fetchExchangesAndPairs(symbol: coin.symbol.lowercased(), completion: { (json) in
//            
//            if json["error"].string != nil {
//                print(json)
//                error()
//                return
//            }
//            
//            
//            for each in json["result"]["markets"]["base"].array! {
//                if !each["active"].bool!{
//                    continue
//                }
//                let exchangeName = each["exchange"].string!
//                
//                var pairName = each["pair"].string!
//                let index = pairName.index(pairName.startIndex, offsetBy: coin.symbol.characters.count)
//                let quote = pairName.substring(from: index)
//                let pair = Pair(base: coin, quote: quote, pair: pairName)
//                if let ex = coin.exchanges[exchangeName] {
//                    coin.exchanges[exchangeName]!.pairs.append(pair)
//                    
//                } else {
//                    coin.exchanges[exchangeName] = Exchange(pairs: [], name: exchangeName)
//                    coin.exchanges[exchangeName]!.pairs.append(pair)
//                }
////                print(each)
//            }
////            coin.exchanges = exchanges
//            completion(coin)
//        })
//        
//    }
//    func fetchAssets(coin: Coin, completion: @escaping (Coin) -> Void) {
//        
//    }
    
    func fetchPair(pair: Pair, exchange: Exchange, completion: @escaping (Pair) -> Void) {
        coinService.fetchPairSummary(pair: pair.pairName, exchange: exchange.name, completion: { (json) in
            var newPair = pair
            newPair.price = json["result"]["price"]["last"].double!
            newPair.percentChange24 = json["result"]["price"]["change"]["percentage"].double!
            newPair.valueChange24 = json["result"]["price"]["change"]["absolute"].double!
            newPair.volume24 = json["result"]["volume"].double!
            completion(newPair)
            
            
        })
    }
    func fetchPrice(of pair: Pair, from exchange: Exchange, completion: @escaping (Pair) -> Void, error: @escaping () -> Void) {
        var exchangeName = exchange.name
        if exchange.name == "CoinMarketCap" {
            exchangeName = "CCCAGG"
        }
        bigService.fetchPrice(for: pair.base.uppercased(), and: pair.quote.uppercased(), inExchange: exchangeName, { (json) in
//            print(json)
            if json["Response"].stringValue == "Error" {
                error()
                return
            }
            let data = json["RAW"][pair.base.uppercased()][pair.quote.uppercased()]
            if exchange.name == "CoinMarketCap" {
                
                pair.lowPrice24 = data["LOW24HOUR"].doubleValue
                pair.highPrice24 = data["HIGH24HOUR"].doubleValue
            } else {
                pair.price = data["PRICE"].doubleValue
                //            pair.price = json["RAW"][pair.base.uppercased()][pair.quote.uppercased()]["PRICE"].stringValue
                pair.highPrice24 = data["HIGH24HOUR"].doubleValue
                pair.volume24 = data["VOLUME24HOURTO"].doubleValue
                pair.valueChange24 = data["CHANGE24HOUR"].doubleValue
                pair.percentChange24 = data["CHANGEPCT24HOUR"].doubleValue
                pair.lowPrice24 = data["LOW24HOUR"].doubleValue
                pair.marketCap = data["MKTCAP"].doubleValue
            }
            
            completion(pair)
            
//            abort()
        })
    }
    
    func fetchChart(of pair: Pair, from exchange: Exchange, for duration: ShowCoin.Duration, completion: @escaping ([(Int, Double, Double, Double, Double, Double)]) -> Void) {
        var exchangeName = exchange.name
        if exchange.name == "CoinMarketCap" {
            exchangeName = "CCCAGG"
        }
//        bigService.fetchMinutePrice(of: pair.base.uppercased(), and: pair.quote.uppercased(), from: exchangeName, { (json) in
//            
////            print(json)
//            var data: [(Int, Double, Double)] = []
//            for period in json["Data"].arrayValue {
//                let time = period["time"].intValue
//                let price = period["close"].doubleValue
//                let volume = period["volumeto"].doubleValue
//                data.append((time,price,volume))
//            }
//            
//            completion(data)
//            
//        })
        bigService.fetchCharts(of: pair.base.uppercased(), and: pair.quote.uppercased(), from: exchangeName, for: duration, { (json) in
            
            //            print(json)
            var data: [(Int, Double, Double, Double, Double, Double)] = []
            for period in json["Data"].arrayValue {
                let time = period["time"].intValue
                let close = period["close"].doubleValue
                let volume = period["volumeto"].doubleValue
                let open = period["open"].doubleValue
                let high = period["high"].doubleValue
                let low = period["low"].doubleValue
                data.append((time, high, low, open , close, volume))
            }
            
            completion(data)
            
        })
    }
    
    
    
    
}

extension Exchange {
    
}

