//
//  LoadingView.swift
//  CryptoTracker
//
//  Created by Zaizen Kaegyoshi on 10/29/17.
//  Copyright © 2017 zaizencorp. All rights reserved.
//

import UIKit
import Charts

class LoadingView: UIView {
    
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var view: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Bundle.main.loadNibNamed("LoadingView", owner: self, options: nil)![0] as! UIView
        
//        Bundle.mainBundle().loadNibNamed("ReusableCustomView", owner: self, options: nil)[0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
        
        self.updatePieChart(assetValue: 100, portfolioValue: 200, color: UIView.theBlue, rotation: 0.0)
    }
    
    func updatePieChart(assetValue: Double, portfolioValue: Double, color: UIColor, rotation: CGFloat) {
        //        let allColors = [color]
        let entry1 = PieChartDataEntry(value: assetValue)
        let entry2 = PieChartDataEntry(value: portfolioValue - assetValue)
        let entry3 = PieChartDataEntry(value: assetValue)
        let entry4 = PieChartDataEntry(value: assetValue)
        let entry5 = PieChartDataEntry(value: assetValue)
        var entries: [PieChartDataEntry] = [entry1, entry2, entry3, entry4, entry5]
        
        let dataSet = PieChartDataSet(values: entries, label: nil)
        
        let data = PieChartData(dataSet: dataSet)
        
        dataSet.drawValuesEnabled = false
        dataSet.colors = ChartColorTemplates.joyful()
        dataSet.valueColors = [UIColor.black]
        pieChart.data = data
        //All other additions to this function will go here
        pieChart.backgroundColor = UIColor.clear
        pieChart.holeColor = UIColor.clear
        pieChart.entryLabelColor = UIColor.clear
        //        pieChartView.centerText = "$76721"
        pieChart.holeRadiusPercent = 0.93
        dataSet.selectionShift = 1
        pieChart.highlightValue(Highlight(x: 0, dataSetIndex: 0, stackIndex: 0))
        dataSet.sliceSpace = 2.0
        
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
        rotatePie(duration: 2.0)
        
//        pieChart.animate(xAxisDuration: 100)
//        pieChart.animate(yAxisDuration: 100)
    }
    func rotatePie(duration: Double) {
        self.pieChart.rotate360Degrees(duration: duration)
//        UIView.animate(withDuration: 0.25, animations: {
//            self.pieChart.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
//        }) { (fin) in
//            self.rotatePie()
//        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
