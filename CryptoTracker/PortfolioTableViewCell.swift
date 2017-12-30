//
//  PortfolioTableViewCell.swift
//  CryptoTracker
//
//  Created by Zaizen Kaegyoshi on 10/29/17.
//  Copyright © 2017 zaizencorp. All rights reserved.
//

import UIKit
import Charts

class PortfolioTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.assetCollection.register(UINib(nibName: "AssetNameCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AssetNameCell")
//        if let flow = self.assetCollection.collectionViewLayout as? UICollectionViewFlowLayout {
//            flow.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
//        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var assetCollection: UICollectionView!
    @IBOutlet weak var currentValueLabel: UIButton!
    @IBOutlet weak var assetNumberLabel: UILabel!
    
    var assets: [String] = []
    
    var assetChange: Double = 0.0
    var assetValue: String = ""
    
    var displayingPercent: Bool = false
    
    var assetSource: AssetCollectionDataSource?
    
    
    func setCell(portfolio: ListPortfolios.FetchPortfolios.ViewModel.DisplayablePortfolio, source: AssetCollectionDataSource) {
//        self.pieChart.heroID = "pieChart"
        
        self.nameLabel.text = portfolio.name
        self.assets = portfolio.assetNames
        self.assetCollection.reloadData()
        self.assetChange = portfolio.assetChange
        self.assetValue = portfolio.assetValue
        self.currentValueLabel.setTitle(portfolio.assetValue, for: .normal)
        self.assetNumberLabel.text = "\(portfolio.assetNames.count) assets"
//        print(assets)
//        portfolio.assetPercents
        self.updatePieChart(assetValues: portfolio.assetPercents, rotation: nil)
        var data: [(Int, Double, Double, Double, Double, Double)] = []
        for i in 0...35 {
            
            let a = (i, Double(Random.random(from: 5, to: 25)), 0.0,0.0,0.0,0.0)
            data.append(a)
        }
//        self.assetCollection.reloadData()
        self.updateGraph(data: data)
        self.assetSource = source
        self.assetCollection.dataSource = assetSource!
        self.assetCollection.reloadData()
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
    func updateGraph(data: [(Int, Double, Double, Double, Double, Double)]) {
        
        if data.count == 0  {
            return
        }
        var lineChartEntries: [ChartDataEntry] = data.map({ ChartDataEntry(x: Double($0.0), y: $0.1) })
        let startPrice = data[0].1
        let endPrice = data.last!.1
        
        //        for i in 0...data.count {
        //            let diceRoll = Int(arc4random_uniform(20) + 1)
        //            let value =  ChartDataEntry(x: Double(i), y: Double(diceRoll))
        //            lineChartEntries.append(value)
        //
        //        }
        
        let line1 = LineChartDataSet(values: lineChartEntries, label: nil)
        
        
        line1.drawCirclesEnabled = false
        line1.drawValuesEnabled = false
        let data = LineChartData()
        data.addDataSet(line1)
        
        
        
        //        self.lineChart.drawGridBackgroundEnabled = false
        self.lineChart.xAxis.drawGridLinesEnabled = false
        self.lineChart.rightAxis.drawGridLinesEnabled = false
        self.lineChart.leftAxis.drawGridLinesEnabled = false
        self.lineChart.legend.enabled = false
        self.lineChart.rightAxis.enabled = false
        self.lineChart.leftAxis.enabled = false
        self.lineChart.xAxis.enabled = false
        self.lineChart.chartDescription = nil
        //        self.lineChart.extraTopOffset = 30.0
        //        self.lineChart.extraBottomOffset = 10.0
        self.lineChart.data?.highlightEnabled = false
        self.lineChart.data = data
        
        
    }
    
}
class AssetCollectionDataSource: NSObject, UICollectionViewDataSource {
    var assetNames: [String] = []
    var colors: [UIColor] = UIView.allColors
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assetNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AssetNameCell", for: indexPath) as! AssetNameCollectionViewCell
        cell.setCell(name: self.assetNames[indexPath.row], color: self.colors[indexPath.row])
        return cell
    }
    
    
}
extension PortfolioTableViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assets.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AssetNameCell", for: indexPath) as! AssetNameCollectionViewCell
//        cell.setCell(name: self.assets[indexPath.item])
        return cell
    }
}

extension PortfolioTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 20)
    }
}

