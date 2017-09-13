//
//  ShowPortfolioPresenter.swift
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

protocol ShowPortfolioPresentationLogic
{
    func presentPortfolio(response: ShowPortfolio.FetchPortfolio.Response)
}

class ShowPortfolioPresenter: ShowPortfolioPresentationLogic
{
  weak var viewController: ShowPortfolioDisplayLogic?
  
  // MARK: Do something
  
    func presentPortfolio(response: ShowPortfolio.FetchPortfolio.Response) {
        let price = String(format: "%.2f", response.value)
        var tempAssets: [ShowPortfolio.FetchPortfolio.ViewModel.DisplayableAsset] = []
        for each in response.assets {
//            if each.assetType != .Fiat {
                let statsPair: Pair = each.coin.exchanges["CoinMarketCap"]!.pairs.first!.value.first!.value
                let totalValue = String(format: "%.2f", each.amountHeld * (statsPair.price)!)
                let price = String(format: "%.2f", (statsPair.price!))
                let percent = String(format: "%.2f", (statsPair.percentChange24!))
                let isUp = statsPair.percentChange24! >= 0
            let a = ShowPortfolio.FetchPortfolio.ViewModel.DisplayableAsset(coinName: each.coin.symbol, amount: "\(each.amountHeld)", totalValue: "$\(totalValue)", price: "$\(price)", change: "\(percent)%", isUp: isUp, total: each.amountHeld * (statsPair.price)!, fiat: each.assetType == .Fiat)
                tempAssets.append(a)
//            }
            
        }
        let gainsValue = response.value - response.initialValue
        var gainsPercent = gainsValue/response.initialValue
        if response.initialValue == 0.0 {
            gainsPercent = 0.0
        }
        
        let vm = ShowPortfolio.FetchPortfolio.ViewModel(totalValue: "$\(price)", overallGainValue: String(format: "$%.2f", gainsValue), overallGainPercent: String(format: "%.2f%", gainsPercent), assets: tempAssets)
        viewController?.displayPortfolio(viewModel: vm)
    }
}
