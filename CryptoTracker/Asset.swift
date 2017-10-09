//
//  Asset.swift
//  CryptoTracker
//
//  Created by Zaizen Kaegyoshi on 9/25/17.
//  Copyright © 2017 zaizencorp. All rights reserved.
//

import Foundation
import RealmSwift

class Asset: Object {

    dynamic var coin: Coin?
    
    dynamic var amountHeld: Double = 0.0
    
    dynamic var initialCost: Double = 0.0
    
    
    
    let buys = List<Transaction>()
    let sells = List<Transaction>()
    
    let portfolios = LinkingObjects(fromType: Portfolio.self, property: "assets")
    
    var portfolio: Portfolio  {
        return portfolios.first!
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
        for transaction in self.buys {
            amount += transaction.amount
//            if transaction.orderType == .Buy {
//
//            } else {
//                amount -= transaction.amount
//            }
            
        }
        for transaction in self.sells {
            amount -= transaction.amount
        }
        var levels = 0.0
        var prevAmount = 0.0
        for transaction in self.buys {
//            if transaction.orderType == .Buy {
            
            levels += transaction.amount
            if amount < levels {
                initTotal += (amount - prevAmount) * transaction.fiatPrice
                return initTotal
            }
            initTotal += transaction.amount * transaction.fiatPrice
            prevAmount = transaction.amount
                
//            }
            
            
        }
        return initTotal
    }
    func updateAmount() {
        var total: Double = 0.0
        for transaction in self.buys {
            
            if transaction.base!.coin!.symbol == self.coin!.symbol {
                total += transaction.amount
            } else {
                total += transaction.amount * transaction.price
            }
            
        }
        for transaction in self.sells {
            
            if transaction.base!.coin!.symbol == self.coin!.symbol {
                total -= transaction.amount
            } else {
                total -= transaction.amount * transaction.price
            }
//            total -= transaction.amount * transaction.price
        }
        self.amountHeld = total
    }
    
//    var coin: Coin
    

    
    
//    enum AssetType: Int {
//        case Fiat
//        case Crypto
//
//    }
//    var assetType: AssetType
    
//    var amountHeld: Double = 0.0
//
//    var transactions: [Transaction] = []
//
//    //    var currentPrice: Double = 0.0
//
//    init(coin: Coin, type: AssetType) {
//        self.coin = coin
//        self.assetType = type
//    }
//
//
//    //    var marketValue: Double {
//    //        return self.amountHeld * self.coin.exchanges["CoinMarketCap"]!.pairs.first!.value.first!.value.price!
//    //    }
    
//
//
//    func addTransaction(transaction: Transaction) {
//        switch transaction.orderType {
//        case .Buy:
//            amountHeld += transaction.amount
//        case .Sell:
//            amountHeld -= transaction.amount
//
//        }
//        self.transactions.append(transaction)
//
//    }
    
    
}
