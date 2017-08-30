//
//  AddTransactionPresenter.swift
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

protocol AddTransactionPresentationLogic
{
    
    func presentCompletedTransaction(response: AddTransaction.SaveTransaction.Response)
    func presentTransaction(response: AddTransaction.LoadTransaction.Response)
}

class AddTransactionPresenter: AddTransactionPresentationLogic
{
    weak var viewController: AddTransactionDisplayLogic?
    
    // MARK: Do something
    
    func presentTransaction(response: AddTransaction.LoadTransaction.Response) {
        let vm = AddTransaction.LoadTransaction.ViewModel(isBuy: response.isBuy, currentPrice: "\(response.currentPrice)", coinName: response.coin.symbol, exchangeNames: response.coin.exchangeNames(), quoteNames: response.exchange.quoteNames(), exchangeName: response.exchangeName, quoteName: response.quoteName)
//        let vm = AddTransaction.LoadTransaction.ViewModel(base: response.pair.base.symbol, quote: response.pair.quote.uppercased(), isBuy: , currentPrice: "\(response.currentPrice)", exchangeName: response.exchange.name.capitalized)
        
        viewController?.displayTransaction(viewModel: vm)
    }
    func presentCompletedTransaction(response: AddTransaction.SaveTransaction.Response) {
        viewController?.dismissCompletedTransaction(viewModel: AddTransaction.SaveTransaction.ViewModel())
    }
}
