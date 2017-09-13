//
//  Portfolio.swift
//  CryptoTracker
//
//  Created by Zaizen Kaegyoshi on 8/25/17.
//  Copyright © 2017 zaizencorp. All rights reserved.
//

import Foundation
import Cereal

class Portfolio {
    
    var value: Double {
        get {
            var val = 0.0
            for asset in self.assets {
                val += asset.amountHeld * asset.coin.exchanges["CoinMarketCap"]!.pairs.first!.value.first!.value.price!
            }
            return val
        }
    }
    
    var initialValue: Double {
        get {
            var initTotal = 0.0
            for asset in self.assets {
                for transaction in asset.transactions {
                    
                    if transaction.isInitialFunding {
                        var coinPrice = 1.0
                        if asset.assetType == .Crypto {
                            coinPrice = transaction.price.usd!
                            
                        }
                        
                        initTotal += transaction.amount*coinPrice
                    }
                    
                }
            }
            return initTotal
        }
    }
    
    var assets: [Asset] = []
    
    func initialValue(of coin: String) -> Double? {
        var initial = 0.0
        if let c = self.find(coin: coin) {
            for asset in self.assets {
                for transaction in asset.transactions {
                    
                    if transaction.isInitialFunding && transaction.pair.base == coin {
                        var coinPrice = 1.0
                        if asset.assetType == .Crypto {
                            coinPrice = transaction.price.usd!
                            
                        }
                        initial += transaction.amount*coinPrice
                    }
                    
                }
            }
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
    init () {
        
    }
    required init(decoder: CerealDecoder) throws {
        self.assets = try decoder.decodeCereal(key: Keys.assets)!
    }
    
    func find(coin: String) -> Asset? {
        for asset in assets {
            if asset.coin.symbol == coin {
                return asset
            }
        }
        return nil
    }
    
    
    
}
extension Portfolio: CerealType {
    struct Keys {
        //        static let notes = "name"
        static let assets = "assets"
//        static let amount = "amount"
        //        static let isInitFund = "isInitFunding"
//        static let assetType = "assetType"
        //        static let exchange = "exchange"
//        static let coinSymbol = "symbol"
        //        static let quoteSymbol = "quote"
        //        static let pairName = "pairName"
    }
    
    func encodeWithCereal(_ encoder: inout CerealEncoder) throws {
        try encoder.encode(self.assets, forKey: Keys.assets)
    }
}

class Asset {
    
    var coin: Coin
    
    
    
    enum AssetType: Int, CerealRepresentable {
        case Fiat
        case Crypto
        
    }
    var assetType: AssetType
    
    var amountHeld: Double = 0.0
    
    var transactions: [Transaction] = []
    
//    var currentPrice: Double = 0.0
    
    init(coin: Coin, type: AssetType) {
        self.coin = coin
        self.assetType = type
    }
    
    var marketValue: Double {
        return self.amountHeld * self.coin.exchanges["CoinMarketCap"]!.pairs.first!.value.first!.value.price!
    }
    var initialValue: Double {
        var initTotal = 0.0
        var amount = 0.0
//        for each in self.transactions {
//            print(each.amount)
//            print(each.price)
//            print(each.orderType)
//            
//        }
        for transaction in self.transactions {
            
            if transaction.orderType == .Buy {
                amount += transaction.amount
            } else {
                amount -= transaction.amount
            }
            
        }
        var levels = 0.0
        var prevAmount = 0.0
        for transaction in self.transactions {
            if transaction.orderType == .Buy {
                
                levels += transaction.amount
                if amount < levels {
                    initTotal += (amount - prevAmount) * transaction.price.usd!
                    return initTotal
                }
                initTotal += transaction.amount * transaction.price.usd!
                prevAmount = transaction.amount
                
            }
            
            
        }
        return initTotal
    }
    
    
    func addTransaction(transaction: Transaction) {
        switch transaction.orderType {
        case .Buy:
            amountHeld += transaction.amount
        case .Sell:
            amountHeld -= transaction.amount
            
        }
        self.transactions.append(transaction)
        
    }
    required init(decoder: CerealDecoder) throws {
        self.transactions = try decoder.decodeCereal(key: Keys.transactions)!
        
        self.amountHeld = try decoder.decode(key: Keys.amount)!
        let coinName: String = try decoder.decode(key: Keys.coinSymbol)!
        
        self.assetType = try decoder.decode(key: Keys.assetType)!
        if self.assetType == .Crypto {
            self.coin = MarketWorker.sharedInstance.coinCollection[coinName]!
        } else {
            let newCoin = Coin(name: coinName, symbol: coinName)
            var temp: [String: [String: Pair]] = [:]
            temp[coinName] = [:]
            var pair = Pair(base: newCoin, quote: coinName, pair: "\(coinName)\(coinName)")
            pair.price = 1.0
            pair.percentChange24 = 0.0
            temp[pair.quote]![pair.quote] = pair
            let exchange = Exchange(pairs: temp, name: "CoinMarketCap")
            newCoin.exchanges["CoinMarketCap"] = exchange
//            asset = Asset(coin: coin, type: .Fiat)
            self.coin = newCoin
        }
        
        
        
    }
    
}
extension Asset: CerealType {
    struct Keys {
//        static let notes = "name"
        static let transactions = "transactions"
        static let amount = "amount"
//        static let isInitFund = "isInitFunding"
        static let assetType = "assetType"
//        static let exchange = "exchange"
        static let coinSymbol = "symbol"
//        static let quoteSymbol = "quote"
//        static let pairName = "pairName"
    }
    func encodeWithCereal(_ encoder: inout CerealEncoder) throws {
//        try encoder.encode(notes, forKey: Keys.notes)
//        try encoder.encode
        try encoder.encode(self.transactions, forKey: Keys.transactions)
        try encoder.encode(amountHeld, forKey: Keys.amount)
        
//        try encoder.encode(isInitialFunding, forKey: Keys.isInitFund)
        try encoder.encode(assetType, forKey: Keys.assetType)
//        try encoder.encode(exchange, forKey: Keys.exchange)
        try encoder.encode(coin.symbol, forKey: Keys.coinSymbol)
//        try encoder.encode(pair.quote, forKey: Keys.quoteSymbol)
//        try encoder.encode(pair.pairName, forKey: Keys.pairName)
    }
}

class Transaction {
    
    enum OrderType: Int, CerealRepresentable {
        case Buy
        case Sell
    }
//    extension OrderType: CerealRepresentable { }
    
    var orderType: OrderType
    
    var isInitialFunding: Bool = false
    
    var datetime: NSDate = NSDate.init(timeIntervalSinceNow: TimeInterval(exactly: 0.0)!)
    
    var pair: Pair
    
    var notes: String = ""
    
    var amount: Double // of base currency
    
    struct Price {
        var original: Double?
        var usd: Double?
        var btc: Double?
    }
    
    var price: Price // in quoted currency
    
    var exchange: String = ""
    
    init(pair: Pair, price: Double, amount: Double, type: OrderType, exchange: String) {
        
        self.exchange = exchange
        self.pair = pair
        let usd: Double = MarketWorker.sharedInstance.coinCollection[pair.base]!.USD
        self.price = Price(original: price, usd: usd, btc: nil)
        
        self.amount = amount
        
        self.orderType = type
    }
    
    
    
    
    
    required init(decoder: CerealDecoder) throws {
        
        let priceOriginal: Double = try decoder.decode(key: Keys.priceOriginal)!
        let priceUSD: Double = try decoder.decode(key: Keys.priceUSD)!
        self.price = Price(original: priceOriginal, usd: priceUSD, btc: nil)
        self.notes = try decoder.decode(key: Keys.notes) ?? ""
        self.amount = try decoder.decode(key: Keys.amount)!
        self.orderType = try decoder.decode(key: Keys.orderType)!
        //        let exchangeName = try decoder.decode(key: Keys.exchange) ?? "CoinMarketCap"
        self.exchange = try decoder.decode(key: Keys.exchange) ?? "CoinMarketCap"
        let base = try decoder.decode(key: Keys.baseSymbol) ?? ""
        let quote = try decoder.decode(key: Keys.quoteSymbol) ?? ""
        let pairName = try decoder.decode(key: Keys.pairName) ?? ""
        let coin = MarketWorker.sharedInstance.coinCollection[base]!
        let pair = Pair(base: coin, quote: quote, pair: pairName)
        self.pair = pair
        
        self.isInitialFunding = try decoder.decode(key: Keys.isInitFund) ?? false
        
    }
    
    
    
}
extension Transaction: CerealType {
    
    struct Keys {
        static let notes = "name"
        static let priceOriginal = "price"
        static let priceUSD = "usd"
        static let amount = "amount"
        static let isInitFund = "isInitFunding"
        static let orderType = "orderType"
        static let exchange = "exchange"
        static let baseSymbol = "base"
        static let quoteSymbol = "quote"
        static let pairName = "pairName"
    }
    func encodeWithCereal(_ encoder: inout CerealEncoder) throws {
        try encoder.encode(notes, forKey: Keys.notes)
        try encoder.encode(price.original!, forKey: Keys.priceOriginal)
        try encoder.encode(price.usd!, forKey: Keys.priceUSD)
        try encoder.encode(amount, forKey: Keys.amount)
        try encoder.encode(isInitialFunding, forKey: Keys.isInitFund)
        
        try encoder.encode(orderType, forKey: Keys.orderType)
        try encoder.encode(exchange, forKey: Keys.exchange)
        try encoder.encode(pair.base, forKey: Keys.baseSymbol)
        try encoder.encode(pair.quote, forKey: Keys.quoteSymbol)
        try encoder.encode(pair.pairName, forKey: Keys.pairName)
        
    }
    
    
}
