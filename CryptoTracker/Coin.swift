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
    var pairs: [String: Pair] = [:]
    
    init(name: String, symbol: String) {
        self.name = name
        self.symbol = symbol
    }
    
    func exchangeNames() -> [String] {
        return Array(self.exchanges.keys)
    }
    func allQuotes() -> [String] {
//        var set = Set<String>()
//        for exchange in self.exchanges {
//            if exchange.value.potentialPairs[self.symbol] != nil {
//                _ = exchange.value.potentialPairs[self.symbol]!.map({ set.insert($0) })
//            }
//            
//        }
        return Array(pairs.keys)
    }
    
    var defaultPair: Pair {
        return self.exchanges[defaultExchangeName]!.pairs[symbol]![defaultFiat]!
    }
    var defaultExchange: Exchange {
        return self.exchanges[defaultExchangeName]!
    }
    
    var defaultChartData: Pair.ChartData {
        return defaultPair.chartData[defaultExchangeName]!
    }
    
    var defaultFiat = "usd"
    var defaultExchangeName = "CoinMarketCap"
    
    required init(decoder: CerealDecoder) throws {
        
        let exchanges: [Exchange] = try decoder.decodeCereal(key: Keys.exchanges)!
        for exchange in exchanges {
            self.exchanges[exchange.name] = exchange
        }
        self.name = try decoder.decode(key: Keys.name)!
        self.symbol = try decoder.decode(key: Keys.symbol)!
    }
    func convert(amount: Double, to coin: String, in exchange: String) -> Double? {
        if self.exchanges[exchange] == nil {
            return nil
        }
        if self.exchanges[exchange]!.pairs[self.symbol]![coin] != nil {
            return amount * self.exchanges[exchange]!.pairs[self.symbol]![coin]!.price!
        } else {
            return nil
        }
//        for each in self.exchanges[exchange]!.pairs[self.symbol] {
//            
//        }
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
    
    var coins: [String: Coin] = [:]
    
    var potentialPairs: [String: [String]] = [:]
    
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
        
        return Array(self.pairs[base.lowercased()]!.keys)
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
    
//    adds empty pair
    mutating func addPair(base: String, quote: String) {
        if self.potentialPairs[base] != nil {
            potentialPairs[base]!.append(quote)
        } else {
            potentialPairs[base] = []
            potentialPairs[base]!.append(quote)
        }
        
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
    
    struct ChartData {
        
        typealias ChartDataType = [(Int, Double,Double, Double, Double, Double)]
        
        var exchange: String
        
        var data: [ShowCoin.Duration: [(Int, Double,Double, Double, Double, Double)]]? = [:]
        
        
//        returns 15 minute candlesticks for 24 hours
        var day: [(Int, Double, Double, Double, Double, Double)]? {
            
            return condense(duration: .Day, constant: 15)
            
        }
        var week: [(Int, Double, Double, Double, Double, Double)]? {
            return data![.Week]
        }
        var month: [(Int, Double, Double, Double, Double, Double)]? {
            return condense(duration: .Month, constant: 3)
        }
        var month3: [(Int, Double, Double, Double, Double, Double)]? {
            return data![.Month3]
        }
        var year: [(Int, Double, Double, Double, Double, Double)]? {
            return data![.Year]
        }
        
        func time(_ duration: ShowCoin.Duration) -> [(Int, Double, Double, Double, Double, Double)]? {
            switch duration {
            case .Day:
                return condense(duration: .Day, constant: 15)
            case .Month:
                return condense(duration: .Month, constant: 3)
            default:
                return data![duration]
            }
            
        }
        
        func condense(duration: ShowCoin.Duration, constant: Int) -> [(Int, Double, Double, Double, Double, Double)]? {
            let d = data![duration]
            if d == nil || d!.count == 0 {
                return d
            }
            
            var inInterval = false
            var newData: [(Int, Double, Double, Double, Double, Double)] = []
            var open = 0.0
            var close = 0.0
            var high = 0.0
            var low = d![0].2
            var vol = 0.0
            
            for (index, each) in d!.enumerated() {
                if !inInterval {
                    inInterval = true
                    high = each.1
                    low = each.2
                    open = each.3
                    close = each.4
                    vol = each.5
                }
                if each.1 > high {
                    high = each.1
                }
                if each.2 < low {
                    low = each.2
                }
                vol += each.5
                if index % constant == 0 {
                    close = each.4
                    let datum = (each.0, high, low, open, close, vol)
                    newData.append(datum)
                    inInterval = false
                }
            }
            
            return newData
        }
        
        
        
        
    }
    
    var base: String
    
    var quote: String
    
    var pairName: String
    
    var price: Double?
    
    var percentChange24: Double?
    
    var valueChange24: Double?
    
    var volume24: Double?
    var volumeString: String {
        return self.toString(d: self.volume24!)
    }
    
    
    var lastPrice: Double?
    
    var highPrice24: Double?
    
    var lowPrice24: Double?
    
    var marketCap: Double?
    var marketCapString: String {
        return self.toString(d: marketCap)
    }
    
    var baseCoin: Coin {
        return MarketWorker.sharedInstance.coinCollection[base]!
    }
    var quoteCoin: Coin? {
        return MarketWorker.sharedInstance.coinCollection[quote]
    }
    

    
    var percentChange7D: Double?
    
    var valueChange7D: Double?
    
    var supply: Double?
    
    var exchanges: [String: Exchange] = [:]
    
    var defaultExchange: Exchange {
        
        if self.quote == "usd" {
            return exchanges["CoinMarketCap"]!
        } else {
            return exchanges.first!.value
        }
        
    }
    
    var chartData: [String: ChartData] = [:]
    
    func toString(d: Double?) -> String {
        if d == nil {
            return ""
        }
        var cap = String(describing: Int(d!))
        
        let length = cap.characters.count
        if length <= 3 {
            cap = "\(String(format: "%.2f",d!))"
            
        } else {
            var index = cap.index(cap.startIndex, offsetBy: 3)
            cap = cap.substring(to: index)
            if length > 9 {
                let decimalPlace = length - 9
                if decimalPlace < 3 {
                    index = cap.index(cap.startIndex, offsetBy: decimalPlace)
                    cap.insert(".", at: index)
                }
                
                cap = "\(cap)B"
            } else if length > 6 {
                let decimalPlace = length - 6
                if decimalPlace < 3 {
                    index = cap.index(cap.startIndex, offsetBy: decimalPlace)
                    cap.insert(".", at: index)
                }
                
                cap = "\(cap)M"
            } else if length > 3{
                let decimalPlace = length - 3
                if decimalPlace < 3 {
                    index = cap.index(cap.startIndex, offsetBy: decimalPlace)
                    cap.insert(".", at: index)
                }
                cap = "\(cap)K"
                
            } else {
                cap = "\(String(format: "%.2f",d!))"
            }
        }
        return cap
    }

    
    init(base: String, quote: String, pair: String) {
        
        self.base = base
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

