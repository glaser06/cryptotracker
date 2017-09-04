//
//  Coin.swift
//  CryptoTracker
//
//  Created by Zaizen Kaegyoshi on 8/25/17.
//  Copyright © 2017 zaizencorp. All rights reserved.
//

import Foundation
import Cereal

class Coin {
    
    var name: String
    
    var symbol: String
    
    
    
//    var overallInfo: OverallStatistics?
    
    var exchanges: [String: Exchange] = [:]
    
    init(name: String, symbol: String) {
        self.name = name
        self.symbol = symbol
    }
    
    func exchangeNames() -> [String] {
        return Array(self.exchanges.keys)
    }
    
    required init(decoder: CerealDecoder) throws {
        
        let exchanges: [Exchange] = try decoder.decodeCereal(key: Keys.exchanges)!
        for exchange in exchanges {
            self.exchanges[exchange.name] = exchange
        }
        self.name = try decoder.decode(key: Keys.name)!
        self.symbol = try decoder.decode(key: Keys.symbol)!
    }
    var USD: Double {
        return self.exchanges["CoinMarketCap"]!.pairs[self.symbol]!["usd"]!.price!
    }
    
}
extension Coin: CerealType {
    struct Keys {
        static let name = "name"
        static let symbol = "symbol"
        static let exchanges = "exchanges"
    }
    func encodeWithCereal(_ encoder: inout CerealEncoder) throws {
        var newExchanges = Array(self.exchanges.values)
        try encoder.encode(newExchanges, forKey: Keys.exchanges)
//        try encoder.encodeIdentifyingItems(newExchanges.CER_casted(), forKey: Keys.exchanges)
        try encoder.encode(name, forKey: Keys.name)
        try encoder.encode(symbol, forKey: Keys.symbol)
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
    init(decoder: CerealDecoder) throws {
        self.name = try decoder.decode(key: Keys.name)!
        var newPairs: [Pair] = try decoder.decodeCereal(key: Keys.pairs)!
        
        var pairDict: [String: [String: Pair]] = [:]
        for pair in newPairs {
            
            if pairDict[pair.base] == nil {
                pairDict[pair.base] = [:]
            }
            pairDict[pair.base]![pair.quote] = pair
        }
        self.pairs = pairDict
//        self.pairs = try decoder.decodeIdentifyingCerealDictionary(key: Keys.pairs)?.CER_casted() ?? [:]
    }
    
}
extension Exchange: CerealType {
    struct Keys {
        static let name = "name"
        static let pairs = "pairs"
    }
    func encodeWithCereal(_ encoder: inout CerealEncoder) throws {
        try encoder.encode(name, forKey: Keys.name)
        var newPairs: [Pair] = []
        for pair in self.pairs {
            for quote in pair.value {
                newPairs.append(quote.value)
            }
        }
        try encoder.encode(newPairs, forKey: Keys.pairs)
        
    }
}

class Pair: NSObject {
    
    var base: String
    
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

    
    var percentChange7D: Double?
    
    var valueChange7D: Double?
    
    var supply: Double?
    

    
    init(base: Coin, quote: String, pair: String) {
        
        self.base = base.symbol
        self.quote = quote
        self.pairName = pair
        super.init()
        do{
            
            try (Mirror(reflecting: self).children.map({(child) throws in
//                print(child.value)
            }))
        } catch {
            
        }
    }
    required init(decoder: CerealDecoder) throws {
        self.base = try decoder.decode(key: Keys.base)!
        self.quote = try decoder.decode(key: Keys.quote)!
        self.pairName = try decoder.decode(key: Keys.pairName)!
        super.init()
        self.price = try decoder.decode(key: Keys.price)
        self.percentChange24 = try decoder.decode(key: Keys.percentChange24)
        self.valueChange24 = try decoder.decode(key: Keys.valueChange24)
        self.volume24 = try decoder.decode(key: Keys.volume24)
        self.lastPrice = try decoder.decode(key: Keys.lastPrice)
        self.highPrice24 = try decoder.decode(key: Keys.highPrice24)
        self.lowPrice24 = try decoder.decode(key: Keys.lowPrice24)
        self.marketCap = try decoder.decode(key: Keys.marketCap)
        self.percentChange7D = try decoder.decode(key: Keys.percentChange7D)
        self.valueChange7D = try decoder.decode(key: Keys.valueChange7D)
        self.supply = try decoder.decode(key: Keys.supply)
        
//        do {
////            print(Mirror(reflecting: self).children.map({ $0.label}))
//            try Mirror(reflecting: self).children.map({(child) throws in
//                print(child.label)
//                if !(["base","quote","pairName"].contains(child.label!)) {
//                    let val: Double = try decoder.decode(key: child.label!)!
//                    self.setValue(val, forKey: child.label!)
//                }
//                
//            })
//        } catch {
//            print("error")
//        }
        
        
    }
    
}
extension Pair: CerealType {
    
    struct Keys {
        static let base = "base"
        static let quote = "quote"
        static let pairName = "pairName"
        static let price = "price"
        static let percentChange24 = "percentChange24"
        static let valueChange24 = "valueChange24"
        static let volume24 = "volume24"
        static let lastPrice = "lastPrice"
        static let highPrice24 = "highPrice24"
        static let lowPrice24 = "lowPrice24"
        static let marketCap = "marketCap"
        static let percentChange7D = "percentChange7D"
        static let valueChange7D = "valueChange7D"
        static let supply = "supply"
    }
    
    func encodeWithCereal(_ encoder: inout CerealEncoder) throws {
        do {
            try Mirror(reflecting: self).children.map({(child) throws in
//                print(child.label)
                if type(of: child.value) == String.self {
                    let c: String = child.value as! String
                    try encoder.encode(c, forKey: child.label!)
                } else {
                    let c: Double? = child.value as? Double
                    try encoder.encode(c, forKey: child.label!)
                }
                
                
            })
        } catch {
            
        }
        
        
        
//        try encoder.encode(base, forKey: Keys.base)
//        try encoder.encode(quote, forKey: Keys.quote)
//        try encoder.encode(pairName, forKey: Keys.pairName)
    }
}

