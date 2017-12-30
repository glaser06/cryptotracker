//
//  Portfolio.swift
//  CryptoTracker
//
//  Created by Zaizen Kaegyoshi on 8/25/17.
//  Copyright © 2017 zaizencorp. All rights reserved.
//

import Foundation
import Cereal
import RealmSwift

class Portfolio: Object {
    
    dynamic var name: String = ""
    let assets = List<Asset>()
    let watchlist = List<Pair>()
    
    override static func primaryKey() -> String? {
        return "name"
    }
    override static func indexedProperties() -> [String] {
        return ["name"]
    }
    
    var marketValue: Double {
        get {
            var val = 0.0
            
//            self.assets.map { (a) -> Double in
//                return a.amountHeld * a.coin!.defaultPair!.price.value!
//            }.reduce(<#T##initialResult: Result##Result#>, <#T##nextPartialResult: (Result, Double) throws -> Result##(Result, Double) throws -> Result#>)
//            print(self.assets.count)
            for asset in self.assets {
                if asset.coin!.coinType == Coin.CoinType.Crypto.rawValue {
//                    print(asset.amountHeld)
                    
                    val += asset.amountHeld * (asset.coin!.defaultPair!.price.value ?? 0.0)
                }
                
            }
//            print(val)
            return val
        }
    }
    var marketValue24hAgo: Double {
        get {
            var val = 0.0
            
            for asset in self.assets {
                if asset.coin!.coinType == Coin.CoinType.Crypto.rawValue {
                    //                    print(asset.amountHeld)
                    
                    val += asset.amountHeld * ((asset.coin!.defaultPair!.price.value ?? 0.0) - (asset.coin?.defaultPair?.valueChange.value ?? 0.0))
                }
                
            }
            //            print(val)
            return val
            
        }
    }
    
    var marketValueChange: Double {
        return self.marketValue - self.marketValue24hAgo
    }
    
    var initialValue: Double {
        get {
            var initTotal = 0.0
            
            
            
            for asset in self.assets {
                for transaction in asset.buys {

                    if transaction.isInitialFunding {
                        var coinPrice = transaction.fiatPrice
//                        if asset.assetType == .Crypto {
//                            coinPrice = transaction.price.usd!
//
//                        }
                        
//                        print(transaction.amount)
                        initTotal += transaction.amount*coinPrice
                    }

                }
            }
            return initTotal
        }
    }
    
//    var assets: [Asset] = []
    
    func cleanWatchlist() {
        let realm = try! Realm()
        
        
        let assets: [String] = self.assets.map { (a) -> String in
            a.coin!.symbol.lowercased()
        }
        
        let tempList = Array(self.watchlist.filter("NOT (quoteSymbol IN %@)", assets))
//        let b: [String] = tempList.map { (c) -> String in
//            c.symbol
//        }
        try! realm.write {
            self.watchlist.removeAll()
//            print(tempList.count)
            for i in tempList {
                self.watchlist.append(i)
            }
//            for (index, coin) in tempList.enumerated() {
//                if self.assets.contains(where: { (a) -> Bool in
//                    return a.coin!.symbol == coin.symbol
//                }) {
//
//                    self.watchlist.append(coin)
//
//                }
//            }
        }
        
    }
    
    func removeFromWatchlist(pair: Pair) {
        let realm = try! Realm()
        let tempList = Array(self.watchlist.filter("id != %@", pair.id))
        try! realm.write {
            
            self.watchlist.removeAll()
            for i in tempList {
                self.watchlist.append(i)
            }
        }
    }
    func addToWatchlist(pair: Pair) {
        let realm = try! Realm()
        
        try! realm.write {
            self.watchlist.append(pair)
        }
    }
    
    func initialValue(of coin: String) -> Double? {
        var initial = 0.0
        if let c = self.find(coin: coin) {
//            for asset in self.assets {
//                for transaction in asset.transactions {
//
//                    if transaction.isInitialFunding && transaction.pair.base == coin {
//                        var coinPrice = 1.0
//                        if asset.assetType == .Crypto {
//                            coinPrice = transaction.price.usd!
//
//                        }
//                        initial += transaction.amount*coinPrice
//                    }
//
//                }
//            }
            return initial
        } else {
            return nil
        }
    }
    
    func updateValue() {
//        for each in assets {
//            
//        }
    }
    
    
    
    func find(coin: String) -> Asset? {
        return assets.filter("coin.symbol = %@", coin).first
//        for asset in assets {
//            if asset.coin.symbol == coin {
//                return asset
//            }
//        }
//        return nil
    }
    
    
    
}








