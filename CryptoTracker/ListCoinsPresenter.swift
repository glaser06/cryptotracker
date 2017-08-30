//
//  ListCoinsPresenter.swift
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

protocol ListCoinsPresentationLogic
{
    func presentCoins(response: ListCoins.FetchCoins.Response)
}

class ListCoinsPresenter: ListCoinsPresentationLogic
{
  weak var viewController: ListCoinsDisplayLogic?
  
  // MARK: Do something
  
  
    func presentCoins(response: ListCoins.FetchCoins.Response) {
        var displayables: [ListCoins.FetchCoins.ViewModel.DisplayableCoin] = []
        for coin in response.coins {
            var cap = coin.cap
            let length = cap.characters.count
            var index = cap.index(cap.startIndex, offsetBy: 3)
            cap = cap.substring(to: index)
            if length > 11 {
                let decimalPlace = length - 11
                if decimalPlace < 3 {
                    index = cap.index(cap.startIndex, offsetBy: decimalPlace)
                    cap.insert(".", at: index)
                }
                
                cap = "$\(cap)B"
            } else if length > 8 {
                let decimalPlace = length - 8
                if decimalPlace < 3 {
                    index = cap.index(cap.startIndex, offsetBy: decimalPlace)
                    cap.insert(".", at: index)
                }
                
                cap = "$\(cap)M"
            }
            
            
            var price = String(coin.price)
            var offset = 7
            if price.characters.count < offset {
                offset = price.characters.count
            }
            index = price.index(price.startIndex, offsetBy: offset)
            price = price.substring(to: index)
            
            let displayable = ListCoins.FetchCoins.ViewModel.DisplayableCoin(symbol: coin.symbol, cap: cap, percentage: "\(coin.percentage)%", price: "$\(price)")
            displayables.append(displayable)
        }
        viewController?.displayCoins(viewModel: ListCoins.FetchCoins.ViewModel(coins: displayables, gotoTransaction: response.gotoTransaction))
    }
}
