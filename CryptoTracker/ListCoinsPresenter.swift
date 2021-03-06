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
    func presentResults(response: ListCoins.SearchCoin.Response)
    
}

class ListCoinsPresenter: ListCoinsPresentationLogic
{
  weak var viewController: ListCoinsDisplayLogic?
  
  // MARK: Do something
    
    func presentResults(response: ListCoins.SearchCoin.Response) {
        var displayables: [ListCoins.DisplayableCoin] = []
        
        for coin in response.coins {
            let cap = coin.cap!
            let name = coin.name!.capitalized
            let symbol = coin.symbol.uppercased()
            
            var price = String(describing: coin.price!)
            var offset = 7
            if price.characters.count < offset {
                offset = price.characters.count
            }
            let index = price.index(price.startIndex, offsetBy: offset)
            price = price.substring(to: index)
            
            let perc = String(format: "%.2f", coin.percentage!)
            
            let displayable = ListCoins.DisplayableCoin(name: name, symbol: symbol, cap: cap, percentage: perc, price: price, isGreen: coin.percentage! >= 0)
            displayables.append(displayable)
            
        }
        self.viewController?.displayResults(viewModel: ListCoins.SearchCoin.ViewModel(coins: displayables))
        
    }
  
    func presentCoins(response: ListCoins.FetchCoins.Response) {
        var displayables: [ListCoins.DisplayableCoin] = []
        for coin in response.coins {
            var cap = coin.cap
            let length = cap.characters.count
            var index = cap.index(cap.startIndex, offsetBy: 3)
            cap = cap.substring(to: index)
            if length > 9 {
                let decimalPlace = length - 9
                if decimalPlace < 3 {
                    index = cap.index(cap.startIndex, offsetBy: decimalPlace)
                    cap.insert(".", at: index)
                }
                
                cap = "$\(cap)B"
            } else if length > 6 {
                let decimalPlace = length - 6
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
//            print(coin.percentage >= 0)
            let displayable = ListCoins.DisplayableCoin(name: coin.name.capitalized, symbol: coin.symbol.uppercased(), cap: cap, percentage: "\(String(format: "%.2f", coin.percentage))%", price: "$\(price)", isGreen: coin.percentage >= 0)
            displayables.append(displayable)
        }
        viewController?.displayCoins(viewModel: ListCoins.FetchCoins.ViewModel(coins: displayables, gotoTransaction: response.gotoTransaction, doSwitch: response.doSwitch))
    }
}
