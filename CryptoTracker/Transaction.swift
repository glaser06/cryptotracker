//
//  Transaction.swift
//  CryptoTracker
//
//  Created by Zaizen Kaegyoshi on 9/25/17.
//  Copyright © 2017 zaizencorp. All rights reserved.
//

import Foundation
import RealmSwift

class Transaction: Object {
    
    dynamic var date: Date = Date()
    
    dynamic var isInitialFunding: Bool = false
    
    dynamic var amount: Double = 0.0
    
    dynamic var notes: String = ""
    
//    dynamic var base: Asset?
    
    let bases = LinkingObjects(fromType: Asset.self, property: "buys")
    var base: Asset? {
        return bases.first
    }
    let quotes = LinkingObjects(fromType: Asset.self, property: "sells")
    var quote: Asset? {
        return quotes.first
    }
    
    dynamic var orderType: Int = OrderType.Buy.rawValue
    
//    dynamic var exchange: Exchange?
    dynamic var pair: Pair? 
    
    dynamic var price: Double = 0.0
    dynamic var btcPrice: Double = 0.0
    dynamic var fiatPrice: Double = 0.0
    
    dynamic var fiat: String = ""
    
    
    enum OrderType: Int {
        case Buy
        case Sell
    }
    //    extension OrderType: CerealRepresentable { }
    
//    var orderType: OrderType
    
    
    
//    var datetime: NSDate = NSDate.init(timeIntervalSinceNow: TimeInterval(exactly: 0.0)!)
    
//    var pair: Pair
    
//    var notes: String = ""
    
//    var amount: Double // of base currency
    
//    struct Price {
//        var original: Double?
//        var usd: Double?
//        var btc: Double?
//    }
//
//    var price: Price // in quoted currency
    
//    var exchange: String = ""
    
//    init(pair: Pair, price: Double, amount: Double, type: OrderType, exchange: String) {
//
//        self.exchange = exchange
//        self.pair = pair
//        //        let usd: Double = MarketWorker.sharedInstance.coinCollection[pair.base]!.USD
//        self.price = Price(original: price, usd: 0.0, btc: nil)
//
//        self.amount = amount
//
//        self.orderType = type
//    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
