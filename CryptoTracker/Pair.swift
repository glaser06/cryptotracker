//
//  Pair.swift
//  CryptoTracker
//
//  Created by Zaizen Kaegyoshi on 9/25/17.
//  Copyright © 2017 zaizencorp. All rights reserved.
//

import Foundation
import RealmSwift

class Pair: Object {
    
    let bases = LinkingObjects(fromType: Coin.self, property: "pairs")
    
    var base: Coin? {
        return bases.first
    }
    
    
    
    let quotes = LinkingObjects(fromType: Coin.self, property: "quotes")
    
    var quote: Coin? {
        return quotes.first
    }
    
    
    
    
    let exchanges = LinkingObjects(fromType: Exchange.self, property: "pairs")
    
    var exchange: Exchange? {
        return exchanges.first
    }
    
    dynamic var baseSymbol: String = ""
    
    func setBase(base: Coin) {
        self.baseSymbol = base.symbol
        self.updateKey()
    }

    
    
    dynamic var quoteSymbol: String = ""
    
    func setQuote(quote: Coin) {
        self.quoteSymbol = quote.symbol
        updateKey()
    }

    
    dynamic var exchangeName: String = ""
    
    func setExchange(exc: Exchange) {
        self.exchangeName = exc.name
        updateKey()
    }
    func setAll(base: Coin, quote: Coin, exc: Exchange) {
        self.setBase(base: base)
        self.setQuote(quote: quote)
        self.setExchange(exc: exc)
    }

    
    public dynamic var id: String = "-"
    
    func compoundKeyValue() -> String {
        return "\(baseSymbol)-\(quoteSymbol)-\(exchangeName)"
    }
    func updateKey() {
        self.id = compoundKeyValue()
    }
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func keyFrom(base: String, quote: String, exchange: String) -> String {
        return "\(base)-\(quote)-\(exchange)"
    }
    
//    dynamic var pairName: String
    
    
    
    let price = RealmOptional<Double>()
    
    let percentChange = RealmOptional<Double>()
    
    let valueChange = RealmOptional<Double>()
    
    let volume = RealmOptional<Double>()
    
    let open = RealmOptional<Double>()
    
    let high = RealmOptional<Double>()
    
    let low = RealmOptional<Double>()
    
    let marketCap = RealmOptional<Double>()
    
    let supply = RealmOptional<Double>()
    
    let charts = List<Chart>()
    
    var marketCapString: String {
        return toString(d: self.marketCap.value)
    }
//    func priceBefore24H() -> Double {
//        if self.valueChange.value == nil || self.valueChange.value! == 0 {
//            self.valueChange.value = se
//        }
//    }
    
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
    func time(_ data: [(Int, Double, Double, Double, Double, Double)], duration: ShowCoin.Duration) -> [(Int, Double, Double, Double, Double, Double)] {
        switch duration {
        case .Day:
            return condense(data, constant: 30)
        case .Week:
            return condense(data, constant: 3)
        case .Month:
            return condense(data, constant: 12)
        default:
            return data
        }
        
    }

    
    func condense(_ data: [(Int, Double, Double, Double, Double, Double)], constant: Int) -> [(Int, Double, Double, Double, Double, Double)] {
        let d = data
//        if d == nil || d.count == 0 {
//            return d
//        }
        
        
        if d.count == 0 {
            return []
        }
        var inInterval = false
        var newData: [(Int, Double, Double, Double, Double, Double)] = []
        var open = 0.0
        var close = 0.0
        var high = 0.0
        var low = d[0].2
        var vol = 0.0
        
        for (index, each) in d.enumerated() {
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


    

class Chart: Object {
    dynamic var duration: String = ""
    
    
    
}
    
    
    
    
    
    
    
    
    
    
//    struct ChartData {
//        
//        typealias ChartDataType = [(Int, Double,Double, Double, Double, Double)]
//        
//        var exchange: String
//        
//        var data: [ShowCoin.Duration: [(Int, Double,Double, Double, Double, Double)]]? = [:]
//        
//        
//        //        returns 15 minute candlesticks for 24 hours
//        var day: [(Int, Double, Double, Double, Double, Double)]? {
//            
//            return condense(duration: .Day, constant: 15)
//            
//        }
//        var week: [(Int, Double, Double, Double, Double, Double)]? {
//            return data![.Week]
//        }
//        var month: [(Int, Double, Double, Double, Double, Double)]? {
//            return condense(duration: .Month, constant: 3)
//        }
//        var month3: [(Int, Double, Double, Double, Double, Double)]? {
//            return data![.Month3]
//        }
//        var year: [(Int, Double, Double, Double, Double, Double)]? {
//            return data![.Year]
//        }
//        
//
//
//    var base: String
//    
//    var quote: String
//    
//    var pairName: String
//    
//    var price: Double?
//    
//    var percentChange24: Double?
//    
//    var valueChange24: Double?
//    
//    var volume24: Double?
//    
//    
//    var volumeString: String {
//        return self.toString(d: self.volume24!)
//    }
//    
//    
//    var lastPrice: Double?
//    
//    var highPrice24: Double?
//    
//    var lowPrice24: Double?
//    
//    var marketCap: Double?
//    var marketCapString: String {
//        return self.toString(d: marketCap)
//    }
//    
//    var baseCoin: Coin {
//        return MarketWorker.sharedInstance.coinCollection[base]!
//    }
//    var quoteCoin: Coin? {
//        return MarketWorker.sharedInstance.coinCollection[quote]
//    }
//    
//    
//    
//    var percentChange7D: Double?
//    
//    var valueChange7D: Double?
//    
//    var supply: Double?
//    
//    var exchanges: [String: Exchange] = [:]
//    
//    var defaultExchange: Exchange {
//        
//        if self.quote == "usd" {
//            return exchanges["CoinMarketCap"]!
//        } else {
//            return exchanges.first!.value
//        }
//        
//    }
//    
//    var chartData: [String: ChartData] = [:]
//    
//
//    
//    init(base: String, quote: String, pair: String) {
//        
//        self.base = base
//        self.quote = quote
//        self.pairName = pair
//        super.init()
//        do{
//            
//            try (Mirror(reflecting: self).children.map({(child) throws in
//                //                print(child.value)
//            }))
//        } catch {
//            
//        }
//    }
//    required init(decoder: CerealDecoder) throws {
//        self.base = try decoder.decode(key: Keys.base)!
//        self.quote = try decoder.decode(key: Keys.quote)!
//        self.pairName = try decoder.decode(key: Keys.pairName)!
//        super.init()
//        self.price = try decoder.decode(key: Keys.price)
//        self.percentChange24 = try decoder.decode(key: Keys.percentChange24)
//        self.valueChange24 = try decoder.decode(key: Keys.valueChange24)
//        self.volume24 = try decoder.decode(key: Keys.volume24)
//        self.lastPrice = try decoder.decode(key: Keys.lastPrice)
//        self.highPrice24 = try decoder.decode(key: Keys.highPrice24)
//        self.lowPrice24 = try decoder.decode(key: Keys.lowPrice24)
//        self.marketCap = try decoder.decode(key: Keys.marketCap)
//        self.percentChange7D = try decoder.decode(key: Keys.percentChange7D)
//        self.valueChange7D = try decoder.decode(key: Keys.valueChange7D)
//        self.supply = try decoder.decode(key: Keys.supply)
//        
//        //        do {
//        ////            print(Mirror(reflecting: self).children.map({ $0.label}))
//        //            try Mirror(reflecting: self).children.map({(child) throws in
//        //                print(child.label)
//        //                if !(["base","quote","pairName"].contains(child.label!)) {
//        //                    let val: Double = try decoder.decode(key: child.label!)!
//        //                    self.setValue(val, forKey: child.label!)
//        //                }
//        //
//        //            })
//        //        } catch {
//        //            print("error")
//        //        }
//        
//        
//    }
//    
//}
//extension Pair: CerealType {
//    
//    struct Keys {
//        static let base = "base"
//        static let quote = "quote"
//        static let pairName = "pairName"
//        static let price = "price"
//        static let percentChange24 = "percentChange24"
//        static let valueChange24 = "valueChange24"
//        static let volume24 = "volume24"
//        static let lastPrice = "lastPrice"
//        static let highPrice24 = "highPrice24"
//        static let lowPrice24 = "lowPrice24"
//        static let marketCap = "marketCap"
//        static let percentChange7D = "percentChange7D"
//        static let valueChange7D = "valueChange7D"
//        static let supply = "supply"
//    }
//    
//    func encodeWithCereal(_ encoder: inout CerealEncoder) throws {
//        do {
//            try Mirror(reflecting: self).children.map({(child) throws in
//                //                print(child.label)
//                if type(of: child.value) == String.self {
//                    let c: String = child.value as! String
//                    try encoder.encode(c, forKey: child.label!)
//                } else {
//                    let c: Double? = child.value as? Double
//                    try encoder.encode(c, forKey: child.label!)
//                }
//                
//                
//            })
//        } catch {
//            
//        }
//        
//        
//        
//        //        try encoder.encode(base, forKey: Keys.base)
//        //        try encoder.encode(quote, forKey: Keys.quote)
//        //        try encoder.encode(pairName, forKey: Keys.pairName)
//    }
//}
