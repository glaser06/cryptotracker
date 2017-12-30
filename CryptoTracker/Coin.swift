//
//  Coin.swift
//  CryptoTracker
//
//  Created by Zaizen Kaegyoshi on 8/25/17.
//  Copyright © 2017 zaizencorp. All rights reserved.
//

import Foundation
import Cereal

import RealmSwift

class Coin: Object {
    
    let fiats: [String] = ["AUD", "BRL", "CAD", "CHF", "CLP", "CNY", "CZK", "DKK", "EUR", "GBP", "HKD", "HUF", "IDR", "ILS", "INR", "JPY", "KRW", "MXN", "MYR", "NOK", "NZD", "PHP", "PKR", "PLN", "RUB", "SEK", "SGD", "THB", "TRY", "TWD", "ZAR", "USD"]
    
    enum CoinType: String {
        case Fiat = "fiat"
        case Crypto = "crypto"
        
    }
    
    dynamic var website: String = ""
    dynamic var details: String = ""
    dynamic var features: String = ""
    dynamic var technologies: String = ""
    dynamic var twitterHandle: String = ""
    dynamic var id: Int = 0
    
    
    
    dynamic var name: String = ""
//    func setName(name: String) {
//        self.name = name
//        self.id = compoundKeyValue()
//    }
    
    dynamic var symbol: String = ""
    func setSymbol(sym: String) {
        self.symbol = sym
        
        if fiats.contains(sym.uppercased()) {
            self.coinType = CoinType.Fiat.rawValue
        } else {
            self.coinType = CoinType.Crypto.rawValue
        }
        
    }
    override static func indexedProperties() -> [String] {
        return ["name", "symbol"]
    }
    
//    public dynamic lazy var id: String = self.compoundKeyValue()
    
//    private func compoundKeyValue() -> String {
//        return "\(name.lowercased())-\(symbol.lowercased())"
//    }
    
    override static func primaryKey() -> String? {
        return "symbol"
    }
    
    dynamic var coinType: String = CoinType.Crypto.rawValue
    
    let pairs = List<Pair>() // where self is base
    let quotes = List<Pair>() // where self is quote
    
    
    var defaultSource: String {
        return "CCCAGG"
    }
    var _defaultPair: Results<Pair>!
    var defaultPair: Pair? {
        
//        let realm = try! Realm()
//        if self.pairs.fil
//        realm.objects(Coin.self).filter("ANY pairs.exchangeName = %@", "CoinMarketCap")
        let a = self.pairs.filter("exchangeName = %@", "CCCAGG")
        if a.count > 0 {
            return a.first!
        } else {
            return nil
        }
//        if self.pairs.contains(where: { (p) -> Bool in
//            return p.exchangeName == "CoinMarketCap"
//        }) {
//            return self.pairs[pairs.index(where: { (p) -> Bool in
//                p.exchangeName == "CoinMarketCap"
//            })!]
//        }
//        return nil
//        let pair = self.pairs.index { (p) -> Bool in
//            print(p.exchangeName)
//            return p.exchangeName == "CoinMarketCap"
//        }
//        if let index = pair {
//            return self.pairs[index]
//        } else {
//            return nil
//        }
//        return self.pairs[pair]
        
    }
    func pair(with quote: String, on exchange: String) -> Pair? {
        return self.pairs.filter("quoteSymbol = %@ AND exchangeName = %@", quote, exchange).first
    }
    func btcPair(on exchange: String) -> Pair? {
        return pair(with: "btc", on: exchange)
    }
    
    
    var nameAndSymbol: String {
        return "\(self.name)-\(self.symbol)"
    }
    
    var exchangeNames: [String] {
        
        return Array(Set(self.pairs.map { (p) -> String in
            p.exchangeName
        }))
    }
    func exchangeNames(for quote: String) -> [String] {
        return Array(Set(self.pairs.filter("quoteSymbol = %@", quote).map { (p) -> String in
            p.exchangeName
        }))
    }
    var quoteSymbols: [String] {
        return Array(Set(self.pairs.map({ (p) -> String in
            p.quoteSymbol
        })))
    }
    
    
    
    
    
    
    
}

    
//    var name: String
//    
//    var symbol: String
//    
//    
//    
////    var overallInfo: OverallStatistics?
//    
//    var exchanges: [String: Exchange] = [:]
//    var pairs: [String: Pair] = [:]
//    
//    init(name: String, symbol: String) {
//        self.name = name
//        self.symbol = symbol
//    }
//    
//    func exchangeNames() -> [String] {
//        return Array(self.exchanges.keys)
//    }
//    func allQuotes() -> [String] {
////        var set = Set<String>()
////        for exchange in self.exchanges {
////            if exchange.value.potentialPairs[self.symbol] != nil {
////                _ = exchange.value.potentialPairs[self.symbol]!.map({ set.insert($0) })
////            }
////            
////        }
//        return Array(pairs.keys)
//    }
//    
//    var defaultPair: Pair {
//        return self.exchanges[defaultExchangeName]!.pairs[symbol]![defaultFiat]!
//    }
//    var defaultExchange: Exchange {
//        return self.exchanges[defaultExchangeName]!
//    }
//    
//    var defaultChartData: Pair.ChartData {
//        return defaultPair.chartData[defaultExchangeName]!
//    }
//    
//    var defaultFiat = "usd"
//    var defaultExchangeName = "CoinMarketCap"
//    
//    required init(decoder: CerealDecoder) throws {
//        
//        let exchanges: [Exchange] = try decoder.decodeCereal(key: Keys.exchanges)!
//        for exchange in exchanges {
//            self.exchanges[exchange.name] = exchange
//        }
//        self.name = try decoder.decode(key: Keys.name)!
//        self.symbol = try decoder.decode(key: Keys.symbol)!
//    }
//    func convert(amount: Double, to coin: String, in exchange: String) -> Double? {
//        if self.exchanges[exchange] == nil {
//            return nil
//        }
//        if self.exchanges[exchange]!.pairs[self.symbol]![coin] != nil {
//            return amount * self.exchanges[exchange]!.pairs[self.symbol]![coin]!.price!
//        } else {
//            return nil
//        }
////        for each in self.exchanges[exchange]!.pairs[self.symbol] {
////            
////        }
//    }
//    var USD: Double {
//        return self.exchanges["CoinMarketCap"]!.pairs[self.symbol]!["usd"]!.price!
//    }
    






