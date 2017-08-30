//
//  ListCoinsInteractor.swift
//  CryptoTracker
//
//  Created by Zaizen Kaegyoshi on 8/23/17.
//  Copyright (c) 2017 zaizencorp. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ListCoinsBusinessLogic
{

    func fetchCoins(request: ListCoins.FetchCoins.Request)
    
}

protocol ListCoinsDataStore
{
    //var name: String { get set }
    var coins: [Coin] { get set }
    var gotoTransaction: Bool? { get set }
}

class ListCoinsInteractor: ListCoinsBusinessLogic, ListCoinsDataStore
{
    var presenter: ListCoinsPresentationLogic?
    var worker: ListCoinsWorker?
    var marketWorker: MarketWorker = MarketWorker()
    
    // MARK: Do something
    var coins: [Coin] = []
    var gotoTransaction: Bool?
    
    func forceRefresh() {
        marketWorker.retrieveCoins(completion: {(c) in})
//        fetchCoins(request: <#T##ListCoins.FetchCoins.Request#>)
    }
    
    func fetchCoins(request: ListCoins.FetchCoins.Request) {
        
        MarketWorker.sharedInstance.exchangeInfoGroup.notify(queue: .main, execute: {
            let coins: [Coin] = Array(MarketWorker.sharedInstance.coinCollection.values).sorted(by: { (coin1,coin2) in
                return coin1.exchanges["CoinMarketCap"]!.pairs.first!.price! > coin2.exchanges["CoinMarketCap"]!.pairs.first!.price!
            })
//            completion(exchanges)
            self.coins = coins
            var responseCoins: [ListCoins.FetchCoins.Response.Coin] = []
            for coin in self.coins {
                let statPair = coin.exchanges["CoinMarketCap"]!.pairs.first!
                let tempCoin = ListCoins.FetchCoins.Response.Coin(symbol: coin.symbol, cap: String(describing: statPair.marketCap!), price: statPair.price!, percentage: statPair.percentChange24!)
                responseCoins.append(tempCoin)
            }
            self.presenter?.presentCoins(response: ListCoins.FetchCoins.Response(coins: responseCoins, gotoTransaction: self.gotoTransaction ?? false))
            request.completion()
        })
        
//        marketWorker.retrieveCoins(completion: { (coins) in
        
            
            
            
//            for data in json {
//                let symbol = data.1["symbol"].string!
//                let cap = data.1["market_cap_usd"].string!
//                let price = Double(data.1["price_usd"].string!)!
//                let percent: Double
//                if let temp = data.1["percent_change_24h"].string {
//                    percent = Double(temp)!
//                } else {
//                    percent = 0.0
//                }
//                let coin = Coin(name: data.1["name"].string!, symbol: symbol)
//                
//                var defaultPair: Pair = Pair(base: coin, quote: "usd", pair: "\(coin.symbol)usd")
//                defaultPair.percentChange24 = percent
//                defaultPair.marketCap = Double(cap)
//                defaultPair.price = price
//                defaultPair.volume24 = Double(data.1["24h_volume_usd"].string!)
//                let defaultExchange = Exchange(pairs: [defaultPair], name: "CoinMarketCap")
//                coin.exchanges["CoinMarketCap"] = defaultExchange
////                coin.overallInfo = Coin.OverallStatistics(marketCap: Double(cap), price: price, percentChange24: percent, valueChange24: nil, percentChange7D: nil, valueChange7D: nil, supply: nil, volume24: Double(data.1["24h_volume_usd"].string!))
////                var usd = Coin(name: "USD", symbol: "USD")
////                var pair = Pair(base: coin, quote: "usd", pair: "\(symbol)usd")
//////                price: price, percentChange24: nil, valueChange24: nil, volume24: nil, lastPrice: nil, highPrice24: nil, lowPrice24: nil)
////                pair.price = price
////                var exchange = Exchange(pairs: [pair], name: "Bitfinex")
////                coin.exchanges["bitfinex"] = exchange
////                let cw = CoinWorker()
//                self.coins.append(coin)
////                MarketWorker.sharedInstance.coinCollection[coin.name] = coin
////                cw.fetchExchanges(coin: coin, completion: { (newCoin) in
////                    self.coins.append(newCoin)
////                    MarketWorker.sharedInstance.coinCollection[newCoin.name] = newCoin
////                }, error: {
////                    
////                })
//                
//                
////                print(data.1["symbol"].string!)
////                print(data.1["market_cap_usd"].string!)
////                print(Double(data.1["price_usd"].string!)!)
////                print(Double(data.1["percent_change_24h"].string!)!)
//                let tempCoin = ListCoins.FetchCoins.Response.Coin(symbol: symbol, cap: cap, price: price, percentage: percent)
//                responseCoins.append(tempCoin)
//            }
            
            
//        })
        
    }
}
