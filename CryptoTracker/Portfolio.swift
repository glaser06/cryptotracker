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
//                val += asset.amountHeld * asset.coin.exchanges["CoinMarketCap"]!.pairs.first!.value.first!.value.price!
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
    init () {
        
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
    
//    var marketValue: Double {
//        return self.amountHeld * self.coin.exchanges["CoinMarketCap"]!.pairs.first!.value.first!.value.price!
//    }
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
//        let usd: Double = MarketWorker.sharedInstance.coinCollection[pair.base]!.USD
        self.price = Price(original: price, usd: 0.0, btc: nil)
        
        self.amount = amount
        
        self.orderType = type
    }
    
    
    
    
    
    
    
    
    
}


