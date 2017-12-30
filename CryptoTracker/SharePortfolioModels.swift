//
//  SharePortfolioModels.swift
//  CryptoTracker
//
//  Created by Zaizen Kaegyoshi on 12/27/17.
//  Copyright (c) 2017 zaizencorp. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import RealmSwift

enum SharePortfolio
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
                
                var amount: String
                
                var totalValue: String
                
                var price: String
                
                var change: String
                
                var isUp: Bool
                
                var total: Double
                
                var fiat: Bool
                
                var cap: String
                
                var volume: String
                
                var portfolioValue: Double
                
                
                
            }
            
            var assets: [DisplayableAsset] = []
        }
    }
    
}