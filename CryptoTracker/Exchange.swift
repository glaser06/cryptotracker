//
//  Exchange.swift
//  CryptoTracker
//
//  Created by Zaizen Kaegyoshi on 9/25/17.
//  Copyright © 2017 zaizencorp. All rights reserved.
//

import Foundation
import RealmSwift

class Exchange: Object {
    
    dynamic var name: String = ""
    
    override static func primaryKey() -> String? {
        return "name"
    }
    
    let pairs = List<Pair>()
    
    override static func indexedProperties() -> [String] {
        return ["name"]
    }
}



    
    
//    var pairs: [String: [String: Pair]] // key is base currency
//    
//    var coins: [String: Coin] = [:]
//    
//    var potentialPairs: [String: [String]] = [:]
//    
//    var name: String
//    
//    init(pairs: [String: [String: Pair]]?, name: String?) {
//        
//        if let n = name {
//            self.name = n
//        } else {
//            self.name = "none"
//        }
//        if let p = pairs {
//            self.pairs = p
//        } else {
//            self.pairs = [:]
//        }
//        
//        
//    }
//    func quoteNames(base: String) -> [String] {
//        var names: [String: String] = [:]
//        
//        return Array(self.pairs[base.lowercased()]!.keys)
//        //
//        //        for pair in self.pairs[base]! {
//        //            names[pair.quote] = ""
//        //        }
//        //        for each in self.exchanges {
//        //            for pair in each.value.pairs {
//        //                names[pair.quote] = ""
//        //            }
//        //        }
//        //        return Array(names.keys)
//    }
//    
//    //    adds empty pair
//    mutating func addPair(base: String, quote: String) {
//        if self.potentialPairs[base] != nil {
//            potentialPairs[base]!.append(quote)
//        } else {
//            potentialPairs[base] = []
//            potentialPairs[base]!.append(quote)
//        }
//        
//    }
//    
//    init(decoder: CerealDecoder) throws {
//        self.name = try decoder.decode(key: Keys.name)!
//        var newPairs: [Pair] = try decoder.decodeCereal(key: Keys.pairs)!
//        
//        var pairDict: [String: [String: Pair]] = [:]
//        for pair in newPairs {
//            
//            if pairDict[pair.base] == nil {
//                pairDict[pair.base] = [:]
//            }
//            pairDict[pair.base]![pair.quote] = pair
//        }
//        self.pairs = pairDict
//        //        self.pairs = try decoder.decodeIdentifyingCerealDictionary(key: Keys.pairs)?.CER_casted() ?? [:]
//    }
//    
//}
//extension Exchange: CerealType {
//    struct Keys {
//        static let name = "name"
//        static let pairs = "pairs"
//    }
//    func encodeWithCereal(_ encoder: inout CerealEncoder) throws {
//        try encoder.encode(name, forKey: Keys.name)
//        var newPairs: [Pair] = []
//        for pair in self.pairs {
//            for quote in pair.value {
//                newPairs.append(quote.value)
//            }
//        }
//        try encoder.encode(newPairs, forKey: Keys.pairs)
//        
//    }
//}
