//
//  Coin.swift
//  CryptoTracker
//
//  Created by Zaizen Kaegyoshi on 8/25/17.
//  Copyright © 2017 zaizencorp. All rights reserved.
//

import Foundation

class Coin {
    
    var name: String
    
    var symbol: String
    
    struct OverallStatistics {
        var marketCap: Double?
        
        var price: Double?
        
        var percentChange24: Double?
        
        var valueChange24: Double?
        
        var percentChange7D: Double?
        
        var valueChange7D: Double?
        
        var supply: Double?
        
        var volume24: Double?
    }
    
//    var overallInfo: OverallStatistics?
    
    var exchanges: [String: Exchange] = [:]
    
    init(name: String, symbol: String) {
        self.name = name
        self.symbol = symbol
    }
    
    func exchangeNames() -> [String] {
        return Array(self.exchanges.keys)
    }
    
    
    
}

struct Exchange {
    
    var pairs: [String: [String: Pair]] // key is base currency
    
    var name: String
    
    init(pairs: [String: [String: Pair]]?, name: String?) {
        
        if let n = name {
            self.name = n
        } else {
            self.name = "none"
        }
        if let p = pairs {
            self.pairs = p
        } else {
            self.pairs = [:]
        }
        
        
    }
    func quoteNames(base: String) -> [String] {
        var names: [String: String] = [:]
        
        return Array(self.pairs[base]!.keys)
//        
//        for pair in self.pairs[base]! {
//            names[pair.quote] = ""
//        }
//        for each in self.exchanges {
//            for pair in each.value.pairs {
//                names[pair.quote] = ""
//            }
//        }
//        return Array(names.keys)
    }
    
}

struct Pair {
    
    var base: Coin
    
    var quote: String
    
    var pairName: String
    
    var price: Double?
    
    var percentChange24: Double?
    
    var valueChange24: Double?
    
    var volume24: Double?
    
    var lastPrice: Double?
    
    var highPrice24: Double?
    
    var lowPrice24: Double?
    
    var marketCap: Double?
    
//    var price: Double?
    
//    var percentChange24: Double?
    
//    var valueChange24: Double?
    
    var percentChange7D: Double?
    
    var valueChange7D: Double?
    
    var supply: Double?
    
//    var volume24: Double?
    
    init(base: Coin, quote: String, pair: String) {
        self.base = base
        self.quote = quote
        self.pairName = pair
    }
    
}
