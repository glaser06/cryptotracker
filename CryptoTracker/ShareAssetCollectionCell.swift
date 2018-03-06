//
//  ShareAssetCollectionCell.swift
//  CryptoTracker
//
//  Created by Zaizen Kaegyoshi on 3/5/18.
//  Copyright © 2018 zaizencorp. All rights reserved.
//

import UIKit
import Charts

class ShareAssetCollectionCell: UICollectionViewCell {
    
    static let identifier = "ShareAssetCollectionCell"
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setCell(asset: SharePortfolio.FetchPortfolio.ViewModel.DisplayableAsset, color: UIColor) {
        
        self.percentLabel.text = String(format: "%.0f", asset.total / asset.portfolioValue * 100)
        self.nameLabel.text = asset.coinName.capitalized
        updatePieChart(assetValue: asset.total, portfolioValue: asset.portfolioValue, color: color, rotation: 0)
        
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
        dataSet.selectionShift = 1
        pieChart.highlightValue(Highlight(x: 0, dataSetIndex: 0, stackIndex: 0))
        dataSet.sliceSpace = 2.0
        
        pieChart.chartDescription = nil
        pieChart.legend.enabled = false
        pieChart.rotationEnabled = false
        pieChart.rotationAngle = rotation - 90
        //        pieChartView.isRotationEnabled = false
        
        //        pieChartView.drawSliceTextEnabled = false
        //        pieChartView.drawSlicesUnderHoleEnabled = true
        //        pieChartView
        
        
        //This must stay at end of function
        pieChart.notifyDataSetChanged()
    }

}
