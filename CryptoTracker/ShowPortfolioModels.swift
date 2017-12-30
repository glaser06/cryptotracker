//
//  ShowPortfolioModels.swift
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

enum ShowPortfolio
{
  // MARK: Use cases
  
  enum FetchPortfolio
  {
    struct Request
    {
    }
    struct Response
    {
        
        var name: String
        var value: Double
        
        var assets: List<Asset>
        var watchlist: List<Pair>
        var initialValue: Double
        var change24H: Double
    }
    struct ViewModel
    {
        
        var name: String
        
        var totalString: String
        
        var overallGainValue: String
        
        var overallGainPercent: String
        
        var initialCost: String
        
        var change24H: String
        
        
        
        struct DisplayableAsset {
            
            var coinName: String
            
            var symbol: String
            
            var amountString: String
            
            var totalValue: String
            
            var price: String
            
            var change: String
            
            var isUp: Bool
            
            var total: Double
            
            var fiat: Bool
            
            var cap: String
            
            var volume: String
            
            var portfolioValue: Double
            
            var amount: Double
            
            
            
        }

        var assets: [DisplayableAsset] = []
        struct DisplayableCoin {
            var name: String
            var symbol: String
            var quoteSymbol: String
            var exchange: String
            var change: String
            var isUp: Bool
            var price: String
            var marketCap: String
            var high: String
            var open: String
            var low: String
            var volume: String
            
            
        }
        
        var watchlist: [DisplayableCoin] = []
    }
  }
    enum FetchAllCoins {
        struct Request {
            
        }
        struct Response {
        
        }
        struct ViewModel {
            
        }
    }
    enum FetchAssetCharts{
        struct Request {
            
        }
        struct Response {
            var data: [String: [String: [(Int, Double, Double, Double, Double, Double)]]]
            
        }
        struct ViewModel {
            var data: [String: [String: [(Int, Double, Double, Double, Double, Double)]]]
            
        }
    }
    enum FetchPortFolioChart{
        struct Request {
            
        }
        struct Response {
            var data: [(Int, Double, Double, Double, Double, Double)]
        }
        struct ViewModel {
            var data: [(Int, Double, Double, Double, Double, Double)]
        }
    }
}
