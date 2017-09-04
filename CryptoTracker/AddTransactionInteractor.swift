//
//  AddTransactionInteractor.swift
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

protocol AddTransactionBusinessLogic
{
    
    func loadTransaction(request: AddTransaction.LoadTransaction.Request)
    
    func saveTransaction(request: AddTransaction.SaveTransaction.Request)
}

protocol AddTransactionDataStore
{
    var coin: Coin? { get set }
    
    var pair: Pair? { get set }
    
    
    var transactionType: Transaction.OrderType { get set }
    
    var exchange: Exchange? { get set }
}

class AddTransactionInteractor: AddTransactionBusinessLogic, AddTransactionDataStore
{
    var presenter: AddTransactionPresentationLogic?
    var portfolioWorker = PortfolioWorker.sharedInstance
    var coinWorker = CoinWorker()
    
    var pair: Pair?
    
    var exchange: Exchange?
    
    var transactionType: Transaction.OrderType = .Buy
    
    var coin: Coin?
    
    
    // MARK: Do something
    
    func saveTransaction(request: AddTransaction.SaveTransaction.Request) {
        
        portfolioWorker.addTransaction(pair: self.pair!, price: request.price, amount: request.amount, isBuy: request.isBuying)
//        print(portfolioWorker.portfolio.assets.count)
        presenter?.presentCompletedTransaction(response: AddTransaction.SaveTransaction.Response())
    }
    func loadTransaction(request: AddTransaction.LoadTransaction.Request) {
        let buy: Bool = self.transactionType == .Buy
        
        var exchangeIndex = 0
        var quoteIndex = 0
        
        
        
        
        if self.pair == nil {
            self.exchange = self.coin!.exchanges.first!.value
            if self.coin!.exchanges.count > 1 {
                self.exchange = Array(self.coin!.exchanges.values)[1]
//                exchangeIndex = 1
            }
            
            self.pair = self.exchange!.pairs[self.coin!.symbol]!.first?.value
        }
        if request.exchangeName != nil {
            self.exchange = self.coin!.exchanges[request.exchangeName!]!
            self.pair = self.exchange!.pairs[self.coin!.symbol]!.first?.value
        }
        if request.quoteName != nil {
            
            for pairs in self.exchange!.pairs[self.coin!.symbol]! {
                if pairs.key == request.quoteName! {
                    self.pair = pairs.value
                }
            }
//            for pairs in self.exchange!.pairs {
//                for pair in pairs {
//                    
//                }
//                
//            }
            //            self.pair = self.exchange?.pairs.find
        }
        
        if self.pair!.price == nil {
            coinWorker.fetchPair(pair: self.pair!, exchange: self.exchange!, completion: { (newPair) in
                self.pair = newPair
                
//                let exchangeNames: [String] = self.coin!.exchangeNames()
//                
//                let quotenames: [String] = self.coin!.quoteNames()
                
                let response = AddTransaction.LoadTransaction.Response(pair: self.pair!, exchange: self.exchange!, isBuy: buy, currentPrice: (self.pair?.price!)!, coin: self.coin!, exchangeName: self.exchange!.name, quoteName: self.pair!.quote )
                self.presenter?.presentTransaction(response: response)
            })
        } else {
            
            let response = AddTransaction.LoadTransaction.Response(pair: self.pair!, exchange: self.exchange!, isBuy: buy, currentPrice: (self.pair?.price!)!, coin: self.coin!, exchangeName: self.exchange!.name, quoteName: self.pair!.quote)
            presenter?.presentTransaction(response: response)
        }
        
    }
}
