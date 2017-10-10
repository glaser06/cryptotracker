//
//  AssetTableViewCell.swift
//  CryptoTracker
//
//  Created by Zaizen Kaegyoshi on 8/25/17.
//  Copyright © 2017 zaizencorp. All rights reserved.
//

import UIKit
import Charts

class AssetTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var valueColorView: UIView!
    
//    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var colorIndicator: UIView!
    @IBOutlet weak var capLabel: UILabel!
    @IBOutlet weak var holdingPercentLabel: UILabel!
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var pieChart: PieChartView!
    
    
    func setCell(asset: ShowPortfolio.FetchPortfolio.ViewModel.DisplayableAsset,  color: UIColor, rotation: CGFloat, data: [(Int, Double, Double, Double, Double, Double)]) {
        
        self.totalValueLabel.text = asset.totalValue
//        self.amountLabel.text = asset.amount
        self.percentLabel.text = asset.change
        self.priceLabel.text = asset.price
        self.symbolLabel.text = asset.symbol.uppercased()
        self.nameLabel.text = asset.coinName.capitalized
        self.valueLabel.text = asset.totalValue
        
//        self.amountLabel.text = asset.amount
        
//        self.colorIndicator.backgroundColor = color
        self.capLabel.text = asset.cap
        self.holdingPercentLabel.text = String(format: "%.0f", asset.total / asset.portfolioValue * 100)
        
        if !asset.isUp {
            self.percentLabel.textColor = UIColor.red
            self.valueColorView.backgroundColor = UIView.theRed
        }
        updateGraph(data: data)
        updatePieChart(assetValue: asset.total, portfolioValue: asset.portfolioValue, color: color, rotation: rotation)
        
    }
    func updatePieChart(assetValue: Double, portfolioValue: Double, color: UIColor, rotation: CGFloat) {
//        let allColors = [color]
        let entry1 = PieChartDataEntry(value: assetValue)
        let entry2 = PieChartDataEntry(value: portfolioValue - assetValue)
        var entries: [PieChartDataEntry] = [entry1, entry2]
        
        let dataSet = PieChartDataSet(values: entries, label: nil)
        
        let data = PieChartData(dataSet: dataSet)
        
        dataSet.drawValuesEnabled = false
        dataSet.colors = [color, UIColor.lightGray]
        dataSet.valueColors = [UIColor.black]
        pieChart.data = data
        //All other additions to this function will go here
        pieChart.backgroundColor = UIColor.clear
        pieChart.holeColor = UIColor.clear
        pieChart.entryLabelColor = UIColor.clear
        //        pieChartView.centerText = "$76721"
        pieChart.holeRadiusPercent = 0.9
        dataSet.selectionShift = 3.0
        pieChart.highlightValue(Highlight(x: 0, dataSetIndex: 0, stackIndex: 0))
        dataSet.sliceSpace = 2.5
        
        pieChart.chartDescription = nil
        pieChart.legend.enabled = false
        pieChart.rotationEnabled = false
        pieChart.rotationAngle = rotation
        //        pieChartView.isRotationEnabled = false
        
        //        pieChartView.drawSliceTextEnabled = false
        //        pieChartView.drawSlicesUnderHoleEnabled = true
        //        pieChartView
        
        
        //This must stay at end of function
        pieChart.notifyDataSetChanged()
    }
    func updateGraph(data: [(Int, Double, Double, Double, Double, Double)]) {
        if data.count == 0  {
            return
        }
        var lineChartEntries: [ChartDataEntry] = data.map({ ChartDataEntry(x: Double($0.0), y: $0.4) })
        let startPrice = data[0].1
        let endPrice = data.last!.1
        
//        for i in 0...data.count {
//            let diceRoll = Int(arc4random_uniform(20) + 1)
//            let value =  ChartDataEntry(x: Double(i), y: Double(diceRoll))
//            lineChartEntries.append(value)
//            
//        }
        
        let line1 = LineChartDataSet(values: lineChartEntries, label: nil)
        let perc = String(format: "%.2f", (endPrice-startPrice)/startPrice * 100)
        self.percentLabel.text = "\(perc)%"
        if startPrice - endPrice < 0 {
            line1.colors = [UIView.theGreen]
            self.percentLabel.textColor = UIView.theGreen
            self.valueColorView.backgroundColor = UIView.theGreen
            
        } else {
            line1.colors = [UIView.theRed]
            self.percentLabel.textColor = UIColor.red
            self.valueColorView.backgroundColor = UIView.theRed
        }
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
