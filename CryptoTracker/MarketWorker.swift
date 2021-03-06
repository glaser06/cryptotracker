//
//  MarketWorker.swift
//  CryptoTracker
//
//  Created by Zaizen Kaegyoshi on 8/23/17.
//  Copyright (c) 2017 zaizencorp. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import SwiftyJSON
import Cereal

class MarketWorker
{
    let marketService = CoinMarketCapAPI()
    let exchangeService = CryptowatchAPI()
    let bigService = CryptocompareAPI()
    
    let exchangeInfoGroup = DispatchGroup()
    
    func retrieveCoins(completion:  ( ([Coin]) -> Void)?) {
//        self.fetchAllExchangesAndPairs()
        self.exchangeInfoGroup.enter()
        marketService.getCoinInfo(completion: { (json) in
            MarketWorker.sharedInstance.topCoins = []
//            self.coins = []
//            let getExchangeInfoGroup = DispatchGroup()
            for data in json {
                let symbol = data.1["symbol"].string!.lowercased()
                let cap = data.1["market_cap_usd"].string!
                let price = Double(data.1["price_usd"].string!)!
                let percent: Double
                if let temp = data.1["percent_change_24h"].string {
                    percent = Double(temp)!
                } else {
                    percent = 0.0
                }
                let coin = Coin(name: data.1["name"].string!, symbol: symbol)
                MarketWorker.sharedInstance.coinCollection[coin.symbol.lowercased()] = coin
                
                let defaultPair: Pair = Pair(base: coin.symbol, quote: "usd", pair: "\(coin.symbol)usd")
                defaultPair.percentChange24 = percent
                defaultPair.marketCap = Double(cap)
                defaultPair.price = price
                defaultPair.volume24 = Double(data.1["24h_volume_usd"].string!)
                
                let cacher = MarketWorker.sharedInstance
                cacher.pairs[coin.symbol] = [:]
                cacher.pairs[coin.symbol]!["usd"] = defaultPair
                
                let defaultName = "CoinMarketCap"
                
//                var tempDict: [String: [String:Pair]] = [:]
//                tempDict[coin.symbol] = [:]
//                tempDict[coin.symbol]!["usd"] = defaultPair
                if cacher.exchanges["CoinMarketCap"] != nil {
                    cacher.exchanges["CoinMarketCap"]!.pairs[coin.symbol] = [:]
                    cacher.exchanges["CoinMarketCap"]!.pairs[coin.symbol]!["usd"] = cacher.pairs[coin.symbol]!["usd"]!
                    cacher.exchanges["CoinMarketCap"]!.coins[coin.symbol] = cacher.coinCollection[coin.symbol]!
                } else {
                    cacher.exchanges["CoinMarketCap"] = Exchange(pairs: nil, name: "CoinMarketCap")
                    cacher.exchanges["CoinMarketCap"]!.pairs[coin.symbol] = [:]
                    cacher.exchanges["CoinMarketCap"]!.pairs[coin.symbol]!["usd"] = cacher.pairs[coin.symbol]!["usd"]!
                    cacher.exchanges["CoinMarketCap"]!.coins[coin.symbol] = cacher.coinCollection[coin.symbol]!
                }
                cacher.pairs[coin.symbol]!["usd"]!.exchanges["CoinMarketCap"] = cacher.exchanges["CoinMarketCap"]!
                
                cacher.coinCollection[coin.symbol]!.exchanges["CoinMarketCap"] = cacher.exchanges["CoinMarketCap"]!
                cacher.coinCollection[coin.symbol]!.pairs["usd"] = cacher.pairs[coin.symbol]!["usd"]
                
                
//                defaultPair.exchanges["CoinMarketCap"] = defaultExchange
//                coin.exchanges["CoinMarketCap"] =  cacher.exchanges["CoinMarketCap"]
//                coin.pairs["usd"] = defaultPair
                
                
//                let cw = CoinWorker()
//                print(coin.symbol)
                
                MarketWorker.sharedInstance.topCoins.append(MarketWorker.sharedInstance.coinCollection[coin.symbol.lowercased()]!)
                
//                MarketWorker.sharedInstance.exchangeInfoGroup.enter()
//                cw.fetchExchanges(coin: coin, completion: { (newCoin) in
////                    self.coins.append(newCoin)
//                    MarketWorker.sharedInstance.coinCollection[newCoin.name] = newCoin
//                    MarketWorker.sharedInstance.exchangeInfoGroup.leave()
//                }, error: {
//                    MarketWorker.sharedInstance.exchangeInfoGroup.leave()
//                })
                
                
                //                print(data.1["symbol"].string!)
                //                print(data.1["market_cap_usd"].string!)
                //                print(Double(data.1["price_usd"].string!)!)
                //                print(Double(data.1["percent_change_24h"].string!)!)
//                let tempCoin = ListCoins.FetchCoins.Response.Coin(symbol: symbol, cap: cap, price: price, percentage: percent)
//                responseCoins.append(tempCoin)
                
            }
            self.fetchAllExchangesAndPairs(completion: {
                if let c = completion {
                    c([])
                }
                
            })
            
            
            
//            self.exchangeInfoGroup.enter()
//            self.exchangeService.fetchAllExchangesAndPairs(completion: { (json) in
//                
//                let results = json["result"]
//                for market in results.dictionaryValue {
//                    let exchangeName: String = market.key.components(separatedBy: ":")[0]
//                    let pairName: String = market.key.components(separatedBy: ":")[1]
//                    let quoteName: String = pairName.substring(from:pairName.index(pairName.endIndex, offsetBy: -3))
//                    let baseName: String = pairName.components(separatedBy: quoteName)[0]
////                    print(quoteName)
////                    print(exchangeName)
////                    print(pairName)
//                    
//                    if MarketWorker.sharedInstance.coinCollection[baseName] != nil {
//                        let p = Pair(base: MarketWorker.sharedInstance.coinCollection[baseName]!.symbol, quote: quoteName, pair: pairName)
//                        if MarketWorker.sharedInstance.exchanges[exchangeName] != nil {
//                            if MarketWorker.sharedInstance.exchanges[exchangeName]!.pairs[baseName] == nil {
//                                MarketWorker.sharedInstance.exchanges[exchangeName]!.pairs[baseName] = [:]
//
//                                MarketWorker.sharedInstance.exchanges[exchangeName]!.pairs[baseName]![quoteName] = p
//                                
//                                
//                            }
//                            
//                            
//                            
//                            
//                            
//                        } else {
//                            MarketWorker.sharedInstance.exchanges[exchangeName] = Exchange(pairs: [:], name: exchangeName)
//                            if MarketWorker.sharedInstance.exchanges[exchangeName]!.pairs[baseName] == nil {
//                                MarketWorker.sharedInstance.exchanges[exchangeName]!.pairs[baseName] = [:]
//                                
//                                MarketWorker.sharedInstance.exchanges[exchangeName]!.pairs[baseName]![quoteName] = p
//                                
//                                
//                            }
//                            
//                            
//
//                        }
//                        MarketWorker.sharedInstance.exchanges[exchangeName]!.pairs[baseName]![quoteName] = p
//                        
//                        MarketWorker.sharedInstance.exchanges[exchangeName]!.pairs[baseName]![quoteName]!.lowPrice24 = market.value["price"]["low"].doubleValue
//                        MarketWorker.sharedInstance.exchanges[exchangeName]!.pairs[baseName]![quoteName]!.highPrice24 = market.value["price"]["high"].doubleValue
//                        MarketWorker.sharedInstance.exchanges[exchangeName]!.pairs[baseName]![quoteName]!.percentChange24 = market.value["price"]["change"]["percentage"].doubleValue
//                        MarketWorker.sharedInstance.exchanges[exchangeName]!.pairs[baseName]![quoteName]!.price = market.value["price"]["last"].doubleValue
//                        MarketWorker.sharedInstance.exchanges[exchangeName]!.pairs[baseName]![quoteName]!.volume24 = market.value["volume"].doubleValue
//
//                        MarketWorker.sharedInstance.coinCollection[baseName]?.exchanges[exchangeName] = MarketWorker.sharedInstance.exchanges[exchangeName]
//                    }
//                    
//                    
//
//                    
//                    
//                    
//                }
//                if let c  = completion {
//                    c([])
//                }
//
//                do  {
//                    try self.saveCoins()
//                } catch {
//                    
//                }
//                self.exchangeInfoGroup.leave()
//                
//                
//                
//                
//                
//            })
            
            
//            MarketWorker.sharedInstance.exchangeInfoGroup.notify(queue: .main, execute: {
//                
//                let exchanges: [Coin] = Array(MarketWorker.sharedInstance.coinCollection.values).sorted(by: { (coin1,coin2) in
//                    return coin1.exchanges["CoinMarketCap"]!.pairs.first!.price! > coin2.exchanges["CoinMarketCap"]!.pairs.first!.price!
//                })
//                completion(exchanges)
//            })
            
        })
        
        
        
    }
    
    
    
    func fetchAllExchangesAndPairs(completion:  ( () -> Void)?) {
//        self.exchangeInfoGroup.enter()
        bigService.fetchAllExchangesAndPairs(completion:  {(json) in
            var allCoins: [String] = []
            for each in json.dictionaryValue {
//                print(each.key)
                let exchangeName = each.key.lowercased()
                if exchangeName == "localbitcoins" {
                    continue
                }
                if self.exchanges[exchangeName] == nil {
                    self.exchanges[exchangeName] = Exchange(pairs: [:], name: each.key)
                }
//                var pairs: [String: [String: Pair]] = [:]
                for symbol in each.value.dictionaryValue {
                    allCoins.append(symbol.key)
                    var coinName = symbol.key.lowercased()
                    if self.coinMapper[coinName] != nil {
                        coinName = self.coinMapper[coinName]!.lowercased()
                    }
                    if let coin = self.coinCollection[coinName] {
                        
                        
                        for quote in symbol.value.arrayValue {
                            let quoteKey = quote.stringValue.lowercased()
                            let pair = Pair(base: coinName, quote: quoteKey, pair: "\(symbol)\(quote)")
                            
                            
                            if self.pairs[coinName] != nil {
                                if self.pairs[coinName]![quoteKey] != nil {
                                    if self.pairs[coinName]![quoteKey]!.exchanges[exchangeName] != nil {
                                        
                                    } else {
                                        self.pairs[coinName]![quoteKey]!.exchanges[exchangeName] = self.exchanges[exchangeName]!
                                    }
                                    
                                    
                                } else {
                                    self.pairs[coinName]![quoteKey] = pair
                                    self.pairs[coinName]![quoteKey]!.exchanges[exchangeName] = self.exchanges[exchangeName]!
                                }
                            } else {
                                self.pairs[coinName] = [:]
                                self.pairs[coinName]![quoteKey] = pair
                                self.pairs[coinName]![quoteKey]!.exchanges[exchangeName] = self.exchanges[exchangeName]!
                            }
                            if self.exchanges[exchangeName]!.pairs[coinName] != nil {
                                
                                if self.exchanges[exchangeName]!.pairs[coinName]![quoteKey] != nil {
                                    
                                } else {
                                    self.exchanges[exchangeName]!.pairs[coinName]![quoteKey] = self.pairs[coinName]![quoteKey]!
                                }
                            } else {
                                self.exchanges[exchangeName]!.coins[coinName] = self.coinCollection[coinName]
                                self.exchanges[exchangeName]!.pairs[coinName] = [:]
                                self.exchanges[exchangeName]!.pairs[coinName]![quoteKey] = self.pairs[coinName]![quoteKey]!
                            }
                            
                            if self.coinCollection[coinName]!.exchanges[exchangeName] != nil {
                                //                            self.coinCollection[symbol.key]!.exchanges[each.key]!.pairs
                                
                                self.coinCollection[coinName]!.pairs[quoteKey] = self.pairs[coinName]![quoteKey]!
                            } else {
                                self.coinCollection[coinName]!.exchanges[exchangeName] = self.exchanges[exchangeName]!
                                self.coinCollection[coinName]!.pairs[quoteKey] = self.pairs[coinName]![quoteKey]!
                                
                            }
                            
                            
                       
                        }
                        
                    }
                    
//                    print(self.coinCollection[coinName]!.exchanges[exchangeName]!.potentialPairs.count)
                    
                }
            }
//            print(self.exchanges)
//            print(self.pairs)
//            print(self.coinCollection)
            
            self.exchangeInfoGroup.leave()
            if let c = completion {
                c()
            }
            
//            allCoins.index(of: "XMR")
            
        })
    }
    
    @objc func updateCoin() {
        print("updating")
        self.retrieveCoins(completion: nil)
    }
    
    static let sharedInstance: MarketWorker = MarketWorker()
    
    var refreshRate: TimeInterval = 300
    
    init() {
        
        
        do {
            
            try self.unpackCoins()
//            self.fetchAllExchangesAndPairs(completion: nil)
        } catch {
            
        }
//        self.retrieveCoins(completion: { (d) in })
        
//        _ = Timer.scheduledTimer(timeInterval: self.refreshRate, target: self, selector: #selector(self.updateCoin), userInfo: nil, repeats: true)
        
    }
    func saveCoins() throws {
        let coins = Array(MarketWorker.sharedInstance.coinCollection.values)
//        print(coins.count)
        var encoder = CerealEncoder()
        
        let data = try CerealEncoder.data(withRoot: coins)
//        let decoder = try CerealDecoder(data: data)
        
//        let coins1: [Coin] = try CerealDecoder.rootCerealItems(with: data)
//        print(coins1.count)
        UserDefaults.standard.set(data, forKey: "coins")
        UserDefaults.standard.synchronize()
    }
    func unpackCoins() throws {
        if let data = UserDefaults.standard.data(forKey: "coins") {
//            let decoder = try CerealDecoder(data: data)
            let coins: [Coin] = try CerealDecoder.rootCerealItems(with: data)
//            let coins: [Coin] = try decoder.decodeIdentifyingCerealArray(key: "coins")?.CER_casted() ?? []
            for coin in coins {
                self.coinCollection[coin.symbol] = coin
            }
        }
        
    }
    
    var coinCollection: [String: Coin] = [:]
    var topCoins: [Coin] = []
    
    
    var exchanges: [String: Exchange] = [:]
    var pairs: [String: [String: Pair]] = [:]
    
    let coinMapper: [String: String] = [
        "iot": "miota",
//        "XBT": "BTC",
    ]
    
//    static let exchanges
}

