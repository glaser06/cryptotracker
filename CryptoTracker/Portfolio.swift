//
//  Portfolio.swift
//  CryptoTracker
//
//  Created by Zaizen Kaegyoshi on 8/25/17.
//  Copyright © 2017 zaizencorp. All rights reserved.
//

import Foundation

class Portfolio {
    
    var value: Double = 0.0
    
    var initialValue: Double = 0.0
    
    var assets: [Asset] = []
    
    func updateValue() {
//        for each in assets {
//            
//        }
    }
    
}

class Asset {
    
    var coin: Coin
    
    var amountHeld: Double = 0.0
    
    var transactions: [Transaction] = []
    
    var currentPrice: Double = 0.0
    
    init(coin: Coin) {
        self.coin = coin
    }
    
    func addTransaction(transaction: Transaction) {
        switch transaction.orderType {
        case .Buy:
            amountHeld += transaction.amount
        case .Sell:
            amountHeld -= transaction.amount
            
        }
        
    }
    
}

class Transaction {
    
    enum OrderType {
        case Buy
        case Sell
    }
    
    var orderType: OrderType
    
    var datetime: NSDate = NSDate.init(timeIntervalSinceNow: TimeInterval(exactly: 0.0)!)
    
    var pair: Pair
    
    
    
    var amount: Double // of base currency
    
    var price: Double // in quoted currency
    
    init(pair: Pair, price: Double, amount: Double, type: OrderType) {
        
        
        self.pair = pair
        
        self.price = price
        
        self.amount = amount
        
        self.orderType = type
    }
    
    
}
