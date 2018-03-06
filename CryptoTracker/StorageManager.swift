//
//  StorageManager.swift
//  CryptoTracker
//
//  Created by Zaizen Kaegyoshi on 10/3/17.
//  Copyright © 2017 zaizencorp. All rights reserved.
//

import Foundation
import RealmSwift

class StorageManager {
//    wrap in realm.write before execution
    
    
    
    
    static func addPair(realm: Realm, base: String, quote: String, exchange: String) -> Pair  {
        
        let base = realm.object(ofType: Coin.self, forPrimaryKey: base.lowercased())!
        let quote = realm.object(ofType: Coin.self, forPrimaryKey: quote.lowercased())!
        let exchange = realm.object(ofType: Exchange.self, forPrimaryKey: exchange)!
        
        return addPair(realm: realm, base: base, quote: quote, exchange: exchange)
    }
    static func addPair(realm: Realm, base: Coin, quote: Coin, exchange: Exchange) -> Pair  {
        
        
        
        let pair = Pair()
        pair.setAll(base: base, quote: quote, exc: exchange)
        
        return addPair(realm: realm, base: base, quote: quote, exchange: exchange, with: pair)
        
        
        
        
        
    }
    static func addPair(realm: Realm, base: Coin, quote: Coin, exchange: Exchange, with pair: Pair) -> Pair {
        
        realm.add(pair, update: true)
        if base.pairs.filter("id = %@", pair.id).first == nil {
            base.pairs.append(pair)
        }
        if quote.quotes.filter("id = %@", pair.id).first == nil {
            quote.quotes.append(pair)
        }
        if exchange.pairs.filter("id = %@", pair.id).first == nil {
//            print(exchange.pairs.count)
//            print(Array(exchange.pairs.map({ (p) -> String in
//                p.quoteSymbol
//            })))
            exchange.pairs.append(pair)
        }
        
        return pair
    }
}
