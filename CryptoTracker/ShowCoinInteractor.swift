//
//  ShowCoinInteractor.swift
//  CryptoTracker
//
//  Created by Zaizen Kaegyoshi on 8/25/17.
//  Copyright (c) 2017 zaizencorp. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import RealmSwift

protocol ShowCoinBusinessLogic
{
//    func doSomething(request: ShowCoin.Something.Request)
    func fetchCoin(request: ShowCoin.ShowCoin.Request)
    func fetchExchangesAndPair(request: ShowCoin.FetchExchangesAndPair.Request, completion: @escaping ()-> Void)
    func fetchHoldings(request: ShowCoin.FetchHoldings.Request)
    
    func fetchCharts(request: ShowCoin.FetchChart.Request, force: Bool)
    func addToWatchlist()
    func removeFromWatchlist()
}

protocol ShowCoinDataStore
{
    //var name: String { get set }
    var coin: Coin? { get set }
//
//    var exchange: Exchange? { get set }
//
//    var pair: Pair? { get set }
    var coinSymbol: String! { get set }
    
    var quoteSymbol: String? { get set }
    
    var exchangeName: String? { get set }
    
    var pair: Pair? { get set }
}

class ShowCoinInteractor: ShowCoinBusinessLogic, ShowCoinDataStore
{

    var presenter: ShowCoinPresentationLogic?
//    var worker: PortfolioWorker = PortfolioWorker.sharedInstance
    var coinWorker: CoinWorker = CoinWorker()
    var portfolioWorker: PortfolioWorker = PortfolioWorker.sharedInstance
    var coin: Coin?
    var exchange: Exchange?
    var pair: Pair?
    
    var coinSymbol: String!
    
    var quoteSymbol: String?
    
    var exchangeName: String?
    
    
    // MARK: Do something
    
    func addToWatchlist() {
        portfolioWorker.addToWatchlist(coin: self.coin!)
        
        presenter?.finishAddToWatchlist()
        
    }
    func removeFromWatchlist() {
        if !portfolioWorker.portfolio.assets.contains(where: { (asset) -> Bool in
            return asset.coin?.symbol == self.coin?.symbol
        }) {
            portfolioWorker.removeFromWatchlist(coin: self.coin!)
            presenter?.finishRemoveFromWatchlist()
        }
        
    }
    
    func fetchHoldings(request: ShowCoin.FetchHoldings.Request) {
//        if let asset = portfolioWorker.portfolio.find(coin: self.coin!.symbol) {
//            let marketValue: Double = MarketWorker.sharedInstance.coinCollection[asset.coin.symbol.lowercased()]!.defaultPair.price! * asset.amountHeld
////            let initValue: Double = portfolioWorker.portfolio.initialValue(of: self.coin!.symbol)!
//            let initValue: Double = asset.initialValue
//            let amount: Double = asset.amountHeld
//            let resp = ShowCoin.FetchHoldings.Response(marketValue: marketValue, initialValue: initValue, amount: amount, totalGain: marketValue-initValue, exists: true)
//            presenter?.presentHoldings(response: resp)
//
//        } else {
//            let resp = ShowCoin.FetchHoldings.Response(marketValue: 0.0, initialValue: 0.0, amount: 0.0, totalGain: 0.0, exists: false)
//            presenter?.presentHoldings(response: resp)
//        }
        let watchlist = portfolioWorker.portfolio.watchlist.contains(self.coin!) || portfolioWorker.portfolio.assets.contains(where: { (asset) -> Bool in
            return asset.coin?.symbol == self.coin?.symbol
        })
        let resp = ShowCoin.FetchHoldings.Response(marketValue: 0.0, initialValue: 0.0, amount: 0.0, totalGain: 0.0, exists: false, watchlist: watchlist)
        presenter?.presentHoldings(response: resp)
        
    }
    func fetchCharts(request: ShowCoin.FetchChart.Request, force: Bool) {
//        if MarketWorker.sharedInstance.pairs[self.pair!.base]![self.pair!.quote]!.chartData[exchange!.name.lowercased()] != nil {
//
//            let data = MarketWorker.sharedInstance.pairs[self.pair!.base]![self.pair!.quote]!.chartData[self.exchange!.name.lowercased()]!
//            if data.time(request.duration) != nil {
//                let resp = ShowCoin.FetchChart.Response(chartData: data.time(request.duration)!)
//                self.presenter?.presentCharts(response: resp)
//                return
//            }
//
//        }
        coinWorker.fetchChart(of: self.pair!, from: self.exchange!, for: request.duration, completion: { (data) in
            var newData: [(Int, Double, Double, Double, Double, Double)] = []

            newData = data
//            if MarketWorker.sharedInstance.pairs[self.pair!.base]![self.pair!.quote]!.chartData[self.exchange!.name.lowercased()] != nil {
//                MarketWorker.sharedInstance.pairs[self.pair!.base]![self.pair!.quote]!.chartData[self.exchange!.name.lowercased()]!.data![request.duration] = newData
//            } else {
//                MarketWorker.sharedInstance.pairs[self.pair!.base]![self.pair!.quote]!.chartData[self.exchange!.name.lowercased()] = Pair.ChartData(exchange: self.exchange!.name, data: [:])
//                MarketWorker.sharedInstance.pairs[self.pair!.base]![self.pair!.quote]!.chartData[self.exchange!.name.lowercased()]!.data![request.duration] = newData
//            }
//            let chart = MarketWorker.sharedInstance.pairs[self.pair!.base]![self.pair!.quote]!.chartData[self.exchange!.name.lowercased()]!.time(request.duration)
            let chart = self.pair!.time(newData, duration: request.duration)
            let resp = ShowCoin.FetchChart.Response(chartData: chart)
            self.presenter?.presentCharts(response: resp)
        })
    }
    
    func fetchCoin(request: ShowCoin.ShowCoin.Request) {
        
        let realm = try! Realm()
        let coin: Coin = self.coin!
        let allQuotes = Array(Set(coin.pairs.map { (p) -> String in
            p.quoteSymbol.uppercased()
        }))
        let allExchanges = Array(Set(coin.pairs.map { (p) -> String in
            p.exchangeName
        }))
        let quotesInExchange = coin.pairs.filter("exchangeName = %@", request.exchange!).map({ (p) -> String in
            p.quoteSymbol.uppercased()
        })
        let exchangesHasQuote = coin.pairs.filter("quoteSymbol = %@", request.quote!.lowercased())
        let exchangeNames = Array(exchangesHasQuote.map({ (p) -> String in
            p.exchangeName
        }))
        

        var pair: Pair
        if request.quote != nil && request.exchange != nil {
            if let p = exchangesHasQuote.filter("exchangeName = %@", request.exchange!).first {
                pair = p
            } else {
                pair = exchangesHasQuote.first!
            }

            
            
            
            
        } else {
            pair = coin.pairs.filter("quoteSymbol = %@ AND exchangeName = %@", "usd", "CoinMarketCap").first!
            
        }
        self.pair = pair
        self.quoteSymbol = pair.quoteSymbol
        let exchange = pair.exchange!
        self.exchange = pair.exchange!
        self.exchangeName = exchange.name
        
        
        
        if self.exchangeName == "CoinMarketCap" {
            
        }
        let resp = ShowCoin.ShowCoin.Response(price: pair.price.value ?? 0.0, percent: pair.percentChange.value ?? 0.0, valueChanged: pair.valueChange.value ?? 0.0, volume: pair.volume.value ?? 0.0, high24: pair.high.value ?? 0.0, low24: pair.low.value ?? 0.0, name: coin.name, symbol: coin.symbol, quote: self.quoteSymbol!, exchange: self.exchangeName!, quotes: allQuotes, exchanges: exchangeNames, cap: pair.toString(d: pair.marketCap.value))
        
        self.presenter?.presentCoin(response: resp)
        
        self.coinWorker.fetchPrice(of: self.coinSymbol, and: self.quoteSymbol!, from: self.exchangeName!, completion: {
            let resp = ShowCoin.ShowCoin.Response(price: pair.price.value, percent: pair.percentChange.value, valueChanged: pair.valueChange.value, volume: pair.volume.value, high24: pair.high.value, low24: pair.low.value, name: coin.name, symbol: coin.symbol, quote: self.quoteSymbol!, exchange: self.exchangeName!, quotes: allQuotes, exchanges: exchangeNames, cap: pair.toString(d: pair.marketCap.value))
            
            self.presenter?.presentCoin(response: resp)
        }, error: {})
        self.fetchCharts(request: ShowCoin.FetchChart.Request(duration: .Day), force: true)
        
//        MarketWorker.sharedInstance.exchangeInfoGroup.notify(queue: .main, execute: {
//
//            if request.quote != nil && request.exchange != nil  {
//
//                let quote = request.quote!.lowercased()
//                if self.coin!.pairs[quote]!.exchanges[request.exchange!] != nil {
//                    self.exchange = self.coin!.pairs[quote]!.exchanges[request.exchange!]!
//
//                } else {
//                    self.exchange = self.coin!.pairs[quote]!.defaultExchange
//                }
//                self.pair = self.coin!.pairs[quote]!
//
////                let resp = ShowCoin.ShowCoin.Response(price: self.pair!.price!, percent: self.pair!.percentChange24, volume: self.pair!.volume24, name: self.coin!.name, symbol: self.coin!.symbol, quote: self.pair!.quote,exchange: request.exchange!, quotes: self.coin!.allQuotes(), exchanges: Array(self.coin!.exchanges.keys))
////                self.presenter?.presentCoin(response: resp)
//
//
////                self.exchange = self.coin!.exchanges[request.exchange!]!
//                self.coinWorker.fetchPrice(of: self.coin!.pairs[quote]!, from: self.exchange!, completion: { (pair) in
//                    MarketWorker.sharedInstance.pairs[pair.base]![pair.quote]! = pair
//                    self.pair = MarketWorker.sharedInstance.pairs[pair.base]![pair.quote]!
//                    let resp = ShowCoin.ShowCoin.Response(price: self.pair!.price!, percent: self.pair!.percentChange24, volume: self.pair!.volume24, high24: self.pair!.highPrice24!, low24: self.pair!.lowPrice24!, name: self.coin!.name, symbol: self.coin!.symbol, quote: self.pair!.quote, exchange: self.exchange!.name, quotes: allQuotes, exchanges: Array(self.coin!.pairs[quote]!.exchanges.keys), cap: self.coin!.defaultPair.marketCapString)
//                    self.presenter?.presentCoin(response: resp)
//                }, error: {
//                    self.exchange = self.coin!.defaultExchange
//                    self.pair = self.coin!.defaultPair
////                    print(self.coin!.pairs[quote]!.exchanges.count)
//                    let resp = ShowCoin.ShowCoin.Response(price: self.pair!.price!, percent: self.pair!.percentChange24, volume: self.pair!.volume24, high24: self.pair!.highPrice24, low24: self.pair!.lowPrice24,name: self.coin!.name, symbol: self.coin!.symbol, quote: self.pair!.quote,exchange: self.exchange!.name, quotes: allQuotes, exchanges: Array(self.coin!.pairs[quote]!.exchanges.keys), cap: self.coin!.defaultPair.marketCapString)
//                    self.presenter?.presentCoin(response: resp)
//                })
//
//            }
//            else {
//                self.exchange = self.coin!.defaultExchange
//                self.pair = self.coin!.defaultPair
//                let resp = ShowCoin.ShowCoin.Response(price: self.pair!.price!, percent: self.pair!.percentChange24, volume: self.pair!.volume24, high24: self.pair!.highPrice24, low24: self.pair!.lowPrice24, name: self.coin!.name, symbol: self.coin!.symbol, quote: self.pair!.quote,exchange: self.exchange!.name, quotes: allQuotes, exchanges: Array(self.coin!.pairs[self.pair!.quote]!.exchanges.keys), cap: self.coin!.defaultPair.marketCapString)
//                self.presenter?.presentCoin(response: resp)
//            }
        
//        })
        return
        
        
        
        
            
            

        
        
        
    }
    func fetchExchangesAndPair(request: ShowCoin.FetchExchangesAndPair.Request, completion: @escaping  () -> Void) {
//        MarketWorker.sharedInstance.exchangeInfoGroup.notify(queue: .main, execute: {
//            let quotes = self.coin!.allQuotes()
//            if let coin = MarketWorker.sharedInstance.coinCollection[self.coin!.symbol] {
//                let exchange = coin.defaultExchange
//
//                let quote = coin.defaultPair.quote
//                let resp = ShowCoin.FetchExchangesAndPair.Response(exchangeName: exchange.name, quote: quote, quotes: quotes)
//                self.presenter?.presentExchangesAndPair(response: resp)
//                completion()
//            } else {
//                let exchange = self.coin!.defaultExchange
//                let quote = self.coin!.defaultPair.quote
//                let resp = ShowCoin.FetchExchangesAndPair.Response(exchangeName: exchange.name, quote: quote, quotes: quotes)
//                self.presenter?.presentExchangesAndPair(response: resp)
//                completion()
//            }
//
//        })
        
        
        
        

    }
    
    
    
}
