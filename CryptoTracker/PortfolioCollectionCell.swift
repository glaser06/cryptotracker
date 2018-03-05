//
//  PortfolioCollectionCell.swift
//  CryptoTracker
//
//  Created by Zaizen Kaegyoshi on 3/5/18.
//  Copyright © 2018 zaizencorp. All rights reserved.
//

import UIKit
import Charts

class PortfolioCollectionCell: UICollectionViewCell {
    
    static let identifier: String = "PortfolioCollectionCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pieChart: PieChartView!
//    @IBOutlet weak var lineChart: LineChartView!
//    @IBOutlet weak var assetCollection: UICollectionView!
    @IBOutlet weak var currentValueLabel: UIButton!
    @IBOutlet weak var assetNumberLabel: UILabel!
    
    var assets: [String] = []
    
    var assetChange: Double = 0.0
    var assetValue: String = ""
    
    var displayingPercent: Bool = false
    
//    var assetSource: AssetCollectionDataSource?
    
    
    func setCell(portfolio: ListPortfolios.FetchPortfolios.ViewModel.DisplayablePortfolio) {
        //        self.pieChart.heroID = "pieChart"
        self.layer.rasterizationScale = UIScreen.main.scale
        self.layer.shouldRasterize = true
        
        self.nameLabel.text = portfolio.name
        self.assets = portfolio.assetNames
//        self.assetCollection.reloadData()
        self.assetChange = portfolio.assetChange
        self.assetValue = portfolio.assetValue
        self.currentValueLabel.setTitle(portfolio.assetValue, for: .normal)
        self.assetNumberLabel.text = "\(portfolio.assetNames.count) assets"
        //        print(assets)
        //        portfolio.assetPercents
        self.updatePieChart(assetValues: portfolio.assetPercents, rotation: nil)
//        var data: [(Int, Double, Double, Double, Double, Double)] = []
//        for i in 0...35 {
//
//            let a = (i, Double(Random.random(from: 5, to: 25)), 0.0,0.0,0.0,0.0)
//            data.append(a)
//        }
        //        self.assetCollection.reloadData()
//        self.updateGraph(data: data)
//        self.assetSource = source
//        self.assetCollection.dataSource = assetSource!
//        self.assetCollection.reloadData()
    }
    @IBAction func switchValueDisplay() {
        var displayed: String = ""
        if displayingPercent {
            displayed = assetValue
            displayingPercent = false
        } else {
            
            displayed = "\(assetChange)"
            displayingPercent = true
            
        }
        self.currentValueLabel.setTitle(displayed, for: .normal)
    }
    func updatePieChart(assetValues: [Double], rotation: CGFloat?) {
        //        let allColors = [color]
        var entries: [PieChartDataEntry] = []
        
        if self.assets.count == 0 {
            let entry = PieChartDataEntry(value: 100)
            entries.append(entry)
            //            self.colorsForAssets.append(UIColor.lightGray)
        }
        else {
            if assetValues.count > 0 {
                for each in assetValues {
                    let entry = PieChartDataEntry(value: each)
                    entries.append(entry)
                }
            } else {
                for name in assets {
                    let entry = PieChartDataEntry(value: 100)
                    entries.append(entry)
                }
            }
            
            
            
            
        }
        //        let entry1 = PieChartDataEntry(value: assetValue)
        //        let entry2 = PieChartDataEntry(value: portfolioValue - assetValue)
        //        let entry3 = PieChartDataEntry(value: assetValue)
        //        let entry4 = PieChartDataEntry(value: assetValue)
        //        let entry5 = PieChartDataEntry(value: assetValue)
        //        var entries: [PieChartDataEntry] = [entry1, entry2, entry3, entry4, entry5]
        
        let dataSet = PieChartDataSet(values: entries, label: nil)
        
        let data = PieChartData(dataSet: dataSet)
        
        dataSet.drawValuesEnabled = false
        
        if self.assets.count == 0 {
            dataSet.colors = [UIColor.lightGray]
        }
        else {
            dataSet.colors = UIView.allColors
        }
        dataSet.valueColors = [UIColor.black]
        pieChart.data = data
        
        pieChart.backgroundColor = UIColor.clear
        pieChart.holeColor = UIColor.clear
        pieChart.entryLabelColor = UIColor.clear
        
        pieChart.holeRadiusPercent = 0.93
        dataSet.selectionShift = 1
        //        pieChart.highlightValue(Highlight(x: 0, dataSetIndex: 0, stackIndex: 0))
        dataSet.sliceSpace = 2.0
        
        pieChart.chartDescription = nil
        pieChart.legend.enabled = false
        pieChart.rotationEnabled = false
        pieChart.rotationAngle = (rotation ?? 0.0) - 90
        //        pieChartView.isRotationEnabled = false
        
        //        pieChartView.drawSliceTextEnabled = false
        //        pieChartView.drawSlicesUnderHoleEnabled = true
        //        pieChartView
        
        
        //This must stay at end of function
        pieChart.notifyDataSetChanged()
        
        
        //        pieChart.animate(xAxisDuration: 100)
        //        pieChart.animate(yAxisDuration: 100)
    }

}
