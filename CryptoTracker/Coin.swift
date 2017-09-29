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
    
    enum CoinType: String {
        case Fiat = "fiat"
        case Crypto = "crypto"
        
    }
    
    dynamic var name: String = ""
//    func setName(name: String) {
//        self.name = name
//        self.id = compoundKeyValue()
//    }
    
    dynamic var symbol: String = ""
//    func setSymbol(sym: String) {
//        self.symbol = sym
//        self.id = compoundKeyValue()
//    }
    
//    public dynamic lazy var id: String = self.compoundKeyValue()
    
//    private func compoundKeyValue() -> String {
//        return "\(name.lowercased())-\(symbol.lowercased())"
//    }
    
    override static func primaryKey() -> String? {
        return "symbol"
    }
    
    dynamic var coinType: String = CoinType.Crypto.rawValue
    
    let pairs = List<Pair>()
    let quotes = List<Pair>()
    
    var defaultPair: Pair? {
//        let realm = try! Realm()
        if self.pairs.contains(where: { (p) -> Bool in
            return p.exchangeName == "CoinMarketCap"
        }) {
            return self.pairs[pairs.index(where: { (p) -> Bool in
                p.exchangeName == "CoinMarketCap"
            })!]
        }
        return nil
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
    var nameAndSymbol: String {
        return "\(self.name)-\(self.symbol)"
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
    






