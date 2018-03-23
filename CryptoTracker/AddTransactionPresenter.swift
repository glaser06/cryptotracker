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
    func presentTransactionError()
    func presentTransaction(response: AddTransaction.LoadTransaction.Response)
}

class AddTransactionPresenter: AddTransactionPresentationLogic
{
    weak var viewController: AddTransactionDisplayLogic?
    
    // MARK: Do something
    
    func presentTransaction(response: AddTransaction.LoadTransaction.Response) {
        var excNames = response.coin.exchangeNames(for: response.quoteName)
//        for (index, each) in excNames.enumerated() {
//            if each == "CCCAGG" {
//                excNames[index] = "CrytoCompare"
//            }
//        }
        var excName = response.exchangeName
//        if response.exchangeName == "CCCAGG" {
//            excName = "CrytoCompare"
//        }
        let vm = AddTransaction.LoadTransaction.ViewModel(isBuy: response.isBuy, currentPrice: "\(response.currentPrice)", coinName: response.coin.symbol, exchangeNames: excNames, quoteNames: response.coin.quoteSymbols, exchangeName: response.exchangeName, quoteName: response.quoteName)


        viewController?.displayTransaction(viewModel: vm)
    }
    func presentCompletedTransaction(response: AddTransaction.SaveTransaction.Response) {
        viewController?.dismissCompletedTransaction(viewModel: AddTransaction.SaveTransaction.ViewModel())
    }
    func presentTransactionError() {
        viewController?.displayTransactionError()
    }
}
