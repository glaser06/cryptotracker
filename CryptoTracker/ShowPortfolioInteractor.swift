//
//  ShowPortfolioInteractor.swift
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

protocol ShowPortfolioBusinessLogic
{
    func fetchPortfolio(request: ShowPortfolio.FetchPortfolio.Request)
    func fetchAllCoins(_ completion: @escaping () -> Void)
    
    func fetchAssetCharts(request: ShowPortfolio.FetchAssetCharts.Request)
    func fetchPortfolioChart()
}

protocol ShowPortfolioDataStore
{
    //var name: String { get set }
}

class ShowPortfolioInteractor: ShowPortfolioBusinessLogic, ShowPortfolioDataStore
{
    var presenter: ShowPortfolioPresentationLogic?
    var portfolioWorker = PortfolioWorker.sharedInstance
    var marketWorker = MarketWorker.sharedInstance
    //var name: String = ""
    
    // MARK: Do something
    
    func fetchPortfolio(request: ShowPortfolio.FetchPortfolio.Request) {
        
//        portfolioWorker.updateAssetPrices()
        marketWorker.exchangeInfoGroup.notify(queue: .main, execute: {
            if self.portfolioWorker.portfolio.assets.count == 0 {
//                self.portfolioWorker.unpackAndSet()
            }
            
            let resp = ShowPortfolio.FetchPortfolio.Response(value: self.portfolioWorker.marketValue(), assets: self.portfolioWorker.portfolio.assets, initialValue: self.portfolioWorker.portfolio.initialValue)
            self.presenter?.presentPortfolio(response: resp)
        })
        
    }
    func fetchAllCoins(_ completion: @escaping () -> Void) {
        self.marketWorker.retrieveCoins(completion: {(d) in
            completion()
            print("done?")
        })
    }
    
    func fetchAssetCharts(request: ShowPortfolio.FetchAssetCharts.Request) {
//        marketWorker.exchangeInfoGroup.notify(queue: .main, execute: {
//
//            self.portfolioWorker.fetchAssetCharts(force: true) {
//                DispatchQueue.global(qos: .userInteractive).async {
//                    let p = self.portfolioWorker.portfolio
//                    let b: [Asset] = p.assets.filter({
//                        $0.assetType != Asset.AssetType.Fiat
//                    }).filter({
//                        $0.amountHeld != 0
//                    })
//                    let c: [[(Int, Double, Double, Double, Double, Double)]] = b.map({ return $0.coin.defaultPair.chartData[$0.coin.defaultExchange.name]!.day! })
//                    let resp = ShowPortfolio.FetchAssetCharts.Response(data: c)
//                    self.presenter?.presentCharts(response: resp)
//                    self.fetchPortfolioChart()
//                }
//            }
//
//        })
        
        
    }
    func fetchPortfolioChart() {
        let data = self.portfolioWorker.constructPortfolioChart()
        self.presenter?.presentPortfolioChart(response: ShowPortfolio.FetchPortFolioChart.Response(data: data))
        
    }
}
