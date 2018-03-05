//
//  ListTransactionsPresenter.swift
//  CryptoTracker
//
//  Created by Zaizen Kaegyoshi on 1/1/18.
//  Copyright (c) 2018 zaizencorp. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ListTransactionsPresentationLogic
{
    func presentTransactions(response: ListTransactions.FetchAsset.Response)
}

class ListTransactionsPresenter: ListTransactionsPresentationLogic
{
    weak var viewController: ListTransactionsDisplayLogic?
    
    // MARK: Do something
    func presentTransactions(response: ListTransactions.FetchAsset.Response) {
        
        var transactions = response.buys + response.sells
        transactions.sort { (a, b) -> Bool in
            a.date < b.date
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let newTs = transactions.map { (t) -> ListTransactions.FetchAsset.ViewModel.DisplayableTransaction in
            
            return ListTransactions.FetchAsset.ViewModel.DisplayableTransaction(pairName: (t.pair?.base?.symbol)!+(t.pair?.quote?.symbol)!, price: "\(t.price)", date: formatter.string(from: t.date), isBuySide: t.orderType == Transaction.OrderType.Buy.rawValue, amount: "\(t.amount)" )
        }
        
        viewController?.displayTransactions(vm: ListTransactions.FetchAsset.ViewModel(transactions: newTs))
        
    }
    
}
