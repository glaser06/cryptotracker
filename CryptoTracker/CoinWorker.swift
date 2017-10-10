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
import RealmSwift

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
    func parseToPair(data: [String: JSON], pair: Pair) {
//        if pair.exchangeName == "CoinMarketCap" {
//            pair.low.value = data["LOW24HOUR"]!.doubleValue
//            pair.high.value = data["HIGH24HOUR"]!.doubleValue
//
//            key = Pair.keyFrom(base: base, quote: quote, exchange: "CCCAGG")
//            if let ccPair = realm.object(ofType: Pair.self, forPrimaryKey: key) {
//                ccPair.price.value = data["PRICE"]!.doubleValue
//
//                ccPair.high.value = data["HIGH24HOUR"]!.doubleValue
//                ccPair.volume.value = data["VOLUME24HOURTO"]!.doubleValue
//                ccPair.valueChange.value = data["CHANGE24HOUR"]!.doubleValue
//                ccPair.percentChange.value = data["CHANGEPCT24HOUR"]!.doubleValue
//                ccPair.low.value = data["LOW24HOUR"]!.doubleValue
//                ccPair.marketCap.value = data["MKTCAP"]!.doubleValue
//            } else {
//
//            }
//
//
//
//        } else {
//            pair.price.value = data["PRICE"]!.doubleValue
//
//            pair.high.value = data["HIGH24HOUR"]!.doubleValue
//            pair.volume.value = data["VOLUME24HOURTO"]!.doubleValue
//            pair.valueChange.value = data["CHANGE24HOUR"]!.doubleValue
//            pair.percentChange.value = data["CHANGEPCT24HOUR"]!.doubleValue
//            pair.low.value = data["LOW24HOUR"]!.doubleValue
//            pair.marketCap.value = data["MKTCAP"]!.doubleValue
//        }
    }
    
    func fetchMultiple(bases: [String], quotes: [String], exchange: Exchange, completion: @escaping () -> Void) {
//        print(bases)
        var excName = exchange.name
        if exchange.name == "CoinMarketCap" {
            excName = "CCCAGG"
        }
        bigService.fetchPriceMulti(for: bases, and: quotes, in: excName) { (json) in
            let prices = json.dictionaryValue
//            print(prices)
            let realm = try! Realm()
            try! realm.write {
                for each in prices {
                    let base = each.key.lowercased()
                    for quote in each.value.dictionaryValue {
                        let quoteSymbol = quote.key.lowercased()
//                        let data = quote.value.dictionaryValue
                        let pair = StorageManager.addPair(realm: realm, base: base, quote: quoteSymbol, exchange: excName)
                        pair.price.value = quote.value.double
                        
                        if exchange.name == "CoinMarketCap" {
                            let coin = realm.object(ofType: Coin.self, forPrimaryKey: base)
                            let pair = coin!.defaultPair!
                            
                        }
                        

                        
                    }
                }
            }
            completion()
            
        }
    }
    
    func fetchPair(pair: Pair, exchange: Exchange, completion: @escaping (Pair) -> Void) {
//        coinService.fetchPairSummary(pair: pair.pairName, exchange: exchange.name, completion: { (json) in
//            var newPair = pair
//            newPair.price = json["result"]["price"]["last"].double!
//            newPair.percentChange24 = json["result"]["price"]["change"]["percentage"].double!
//            newPair.valueChange24 = json["result"]["price"]["change"]["absolute"].double!
//            newPair.volume24 = json["result"]["volume"].double!
//            completion(newPair)
//
//
//        })
    }
    func fetchPrice(of base: String, and quote: String, from exchange: String, completion: @escaping () -> Void, error: @escaping () -> Void) {
        let quote = quote.lowercased()
        let base = base.lowercased()
        var exchangeName: String = exchange
        if exchange == "CoinMarketCap" {
            exchangeName = "CCCAGG"
        }
        let realm = try! Realm()
        bigService.fetchPrice(for: base.uppercased(), and: quote.uppercased(), inExchange: exchangeName, { (json) in
            if json["Response"].stringValue == "Error" {
                error()
                return
            }
            let data = json["RAW"][base.uppercased()][quote.uppercased()]
            try! realm.write {
                var key: String = Pair.keyFrom(base: base, quote: quote, exchange: exchange)
                let pair = realm.object(ofType: Pair.self, forPrimaryKey: key)!
                
                if exchange == "CoinMarketCap" {
                    pair.low.value = data["LOW24HOUR"].doubleValue
                    pair.high.value = data["HIGH24HOUR"].doubleValue
                    
                    key = Pair.keyFrom(base: base, quote: quote, exchange: "CCCAGG")
                    if let ccPair = realm.object(ofType: Pair.self, forPrimaryKey: key) {
                        ccPair.price.value = data["PRICE"].doubleValue
                        
                        ccPair.high.value = data["HIGH24HOUR"].doubleValue
                        ccPair.volume.value = data["VOLUME24HOURTO"].doubleValue
                        ccPair.valueChange.value = data["CHANGE24HOUR"].doubleValue
                        ccPair.percentChange.value = data["CHANGEPCT24HOUR"].doubleValue
                        ccPair.low.value = data["LOW24HOUR"].doubleValue
                        ccPair.marketCap.value = data["MKTCAP"].doubleValue
                    } else {
                        
                    }
                    
                    
                    
                } else {
                    pair.price.value = data["PRICE"].doubleValue
                    
                    pair.high.value = data["HIGH24HOUR"].doubleValue
                    pair.volume.value = data["VOLUME24HOURTO"].doubleValue
                    pair.valueChange.value = data["CHANGE24HOUR"].doubleValue
                    pair.percentChange.value = data["CHANGEPCT24HOUR"].doubleValue
                    pair.low.value = data["LOW24HOUR"].doubleValue
                    pair.marketCap.value = data["MKTCAP"].doubleValue
                }
            }
            
            
            completion()
        })
//        var exchangeName = exchange.name
//        if exchange.name == "CoinMarketCap" {
//            exchangeName = "CCCAGG"
//        }
        
//            print(json)
        

//            abort()
//        })
    }
    
    func fetchChart(of pair: Pair, from exchange: Exchange, for duration: ShowCoin.Duration, completion: @escaping ([(Int, Double, Double, Double, Double, Double)]) -> Void) {
        var exchangeName = exchange.name
        if exchange.name == "CoinMarketCap" {
            exchangeName = "CCCAGG"
        }

        bigService.fetchCharts(of: pair.baseSymbol.uppercased(), and: pair.quoteSymbol.uppercased(), from: exchangeName, for: duration, { (json) in
            
            //            print(json)
            var data: [(Int, Double, Double, Double, Double, Double)] = []
            for period in json["Data"].arrayValue {
                let time = period["time"].intValue
                let close = period["close"].doubleValue
                let volume =  period["volumefrom"].doubleValue //+ period["volumeto"].doubleValue
                let open = period["open"].doubleValue
                let high = period["high"].doubleValue
                let low = period["low"].doubleValue
                data.append((time, high, low, open , close, volume))
            }
            
            completion(data)
            
        })
    }
    
    
    
    
}



