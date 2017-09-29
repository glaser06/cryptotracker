//
//  ShowPortfolioViewController.swift
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
import Charts
import YIInnerShadowView

protocol ShowPortfolioDisplayLogic: class
{
    func displayPortfolio(viewModel: ShowPortfolio.FetchPortfolio.ViewModel)
    func displayCharts(viewModel: ShowPortfolio.FetchAssetCharts.ViewModel)
    func displayPortfolioChart(viewModel: ShowPortfolio.FetchPortFolioChart.ViewModel)
}

class ShowPortfolioViewController: UIViewController, ShowPortfolioDisplayLogic
{
    var interactor: ShowPortfolioBusinessLogic?
    var router: (NSObjectProtocol & ShowPortfolioRoutingLogic & ShowPortfolioDataPassing)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = ShowPortfolioInteractor()
        let presenter = ShowPortfolioPresenter()
        let router = ShowPortfolioRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    var assets: [ShowPortfolio.FetchPortfolio.ViewModel.DisplayableAsset] = []
    var assetsOnDisplay: [ShowPortfolio.FetchPortfolio.ViewModel.DisplayableAsset] = []
//    var allColors: [NSUIColor] = ChartColorTemplates.joyful() + ChartColorTemplates.liberty() + ChartColorTemplates.pastel() + ChartColorTemplates.vordiplom() + ChartColorTemplates.material() + ChartColorTemplates.colorful()
    var colorsForAssets: [NSUIColor] = []
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        let p = PortfolioWorker.sharedInstance
        self.view.bringSubview(toFront: self.menuView)
        self.lineChart.delegate = self
            
//        self.getAllCoins()
        
        
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        setupAssetTable()
        setupMenu()
        
//        fetchPortfolio()
//        pieChartUpdate()
        
        
        
        
        self.menuView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
//        reload()
    }
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    func setupMenu() {
//        self.menuView.isHidden = false
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.menuView)
//        self.navigationController?.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.menuView)
//        var view = menuBarButton.customView!
//        view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: 44.0, height: 44.0)
//        
//        view.layer.cornerRadius = 22.0
//        menuBarButton.customView = view
//        self.view.setNeedsLayout()
//        self.view.layoutIfNeeded()
        
    }
    func drawShadow(view: UIView) -> UIView {
//        if nil == view.layer.shad {
        let size = view.frame.size
        view.clipsToBounds = true
        let layer: CALayer = CALayer()
        layer.backgroundColor = UIColor.lightGray.cgColor
        layer.position = CGPoint(x: size.width / 2, y: -size.height / 2 + 0.5)
        layer.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
//        layer.bounds = CGRect(0, 0, size.width, size.height)
        layer.shadowColor = UIColor.darkGray.cgColor

        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 1.0
//            view.shadowLayer = layer
    
        view.layer.addSublayer(layer)
        return view
//        }
    }
    
    
    func getAllCoins() {
        interactor?.fetchAllCoins {
            let p = PortfolioWorker.sharedInstance.portfolio
            print(p)
            self.reload()
//            self.fetchCharts()
        }
    }
    
    func setupAssetTable() {
        assetTableView.tableFooterView = UIView()
        assetTableView.register(UINib(nibName: "AssetTableViewCell", bundle: nil), forCellReuseIdentifier: "AssetCell")
        
        assetTableView.rowHeight = UITableViewAutomaticDimension
        assetTableView.estimatedRowHeight = 200
    }
    
    // MARK: Do something
    
    @IBOutlet weak var assetTableView: UITableView!
    @IBOutlet weak var transactionButton: UIButton!
    
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var chartValueLabel: UILabel!
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var totalGainsLabel: UILabel!
    
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var lineChart: LineChartView!
    
    @IBOutlet var assetSwitches: [UIButton]!
    @IBOutlet var selectorViews: [UIView]!
    
    @IBOutlet weak var menuView: UIView!
    
    var theBlue: UIColor {
        return self.selectorViews[0].backgroundColor!
    }
    var selectedAssets: Int = 1
    
    @IBAction func reload() {
        
        fetchPortfolio()
        pieChartUpdate()
//        lineChartUpdate()
        fetchCharts()
        
    }
    
    func fetchPortfolio() {
        interactor?.fetchPortfolio(request: ShowPortfolio.FetchPortfolio.Request())
    }
    func fetchCharts() {
        interactor?.fetchAssetCharts(request: ShowPortfolio.FetchAssetCharts.Request())
    }
    
    func displayPortfolio(viewModel: ShowPortfolio.FetchPortfolio.ViewModel) {
        
        
        
        self.assets = viewModel.assets
        self.pieChartUpdate()
//        self.lineChartUpdate()
        let tempButton = UIButton()
        tempButton.tag = self.selectedAssets
        self.changeAssetsDisplayed(sender: tempButton)
        
        let price = viewModel.totalValue
        self.totalValueLabel.text = price
        self.chartValueLabel.text = price
        
        self.totalGainsLabel.text = "\(viewModel.overallGainValue)"
//        (\(viewModel.overallGainPercent))
        self.assetTableView.reloadData()
        pieChartUpdate()
        
        self.tableHeight.constant = assetTableView.contentSize.height
        
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        
    }
    var chartData: [[(Int, Double, Double, Double, Double, Double)]] = []
    
    func displayCharts(viewModel: ShowPortfolio.FetchAssetCharts.ViewModel) {
        self.chartData = viewModel.data
        self.assetTableView.reloadData()
    }
    
    
    func displayPortfolioChart(viewModel: ShowPortfolio.FetchPortFolioChart.ViewModel) {
        lineChartUpdate(data: viewModel.data)
    }
    
    
    
    func lineChartUpdate(data: [(Int, Double, Double, Double, Double, Double)]) {
        if data.count == 0 {
            return
        }
        var lineChartEntries: [ChartDataEntry] = data.map({ChartDataEntry(x: Double($0.0), y: $0.4)})
        
        let start = lineChartEntries.first!.y
        let end = lineChartEntries.last!.y
        
//        for i in 0...96 {
//            
//            let diceRoll = Int(arc4random_uniform(20) + 1)
//            let value =  ChartDataEntry(x: Double(i), y: sin(Double(i)/180 * Double.pi))
//            lineChartEntries.append(value)
//
//        }
        let line1 = LineChartDataSet(values: lineChartEntries, label: nil)
        line1.colors = [ChartColorTemplates.joyful()[0]]
        if end - start > 0 {
            line1.colors = [UIView.theGreen]
        } else {
            line1.colors = [UIView.theRed]
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
        self.lineChart.extraTopOffset = 50.0
//        self.lineChart.extraBottomOffset = 10.0
        self.lineChart.data?.highlightEnabled = false
        self.lineChart.data = data
    }
    func pieChartUpdate() {
        let allColors: [NSUIColor] = ChartColorTemplates.joyful() + ChartColorTemplates.liberty() + ChartColorTemplates.pastel() + ChartColorTemplates.vordiplom() + ChartColorTemplates.material() + ChartColorTemplates.colorful()
        
        var entries: [PieChartDataEntry] = []
        for (index,asset) in self.assets.enumerated() {
            let entry = PieChartDataEntry(value: asset.total)
            entries.append(entry)
            self.colorsForAssets.append(allColors[index])
        }
//        let entry1 = PieChartDataEntry(value: 20, label: nil)
//        let entry2 = PieChartDataEntry(value: 30, label: nil)
//        let entry3 = PieChartDataEntry(value: 40, label: nil)
        
        
        let dataSet = PieChartDataSet(values: entries, label: nil)
        
        let data = PieChartData(dataSet: dataSet)
         
        
        
        
//        pieChartView.chartDescription?.text = "Share of Widgets by Type"
        dataSet.drawValuesEnabled = false
        dataSet.colors = allColors
        dataSet.valueColors = [UIColor.black]
        pieChartView.data = data
        //All other additions to this function will go here
        pieChartView.backgroundColor = UIColor.clear
        pieChartView.holeColor = UIColor.clear
        pieChartView.entryLabelColor = UIColor.clear
//        pieChartView.centerText = "$76721"
        pieChartView.holeRadiusPercent = 0.93
        dataSet.selectionShift = 0.0
        pieChartView.chartDescription = nil
        pieChartView.legend.enabled = false
        pieChartView.rotationEnabled = false
//        pieChartView.isRotationEnabled = false
        
//        pieChartView.drawSliceTextEnabled = false
//        pieChartView.drawSlicesUnderHoleEnabled = true
//        pieChartView
        
        
        //This must stay at end of function
        pieChartView.notifyDataSetChanged()
    }
    
    
    
    @IBAction func changeAssetsDisplayed(sender: UIButton) {
        self.selectedAssets = sender.tag
        let prevHeight = self.tableHeight.constant
        switch sender.tag {
        case 1:
            self.assetsOnDisplay = []
            for asset in self.assets {
                if asset.total > 0 && !asset.fiat {
                    self.assetsOnDisplay.append(asset)
                }
            }
            
        case 2:
            self.assetsOnDisplay = []
            for asset in self.assets {
                if asset.fiat {
                    self.assetsOnDisplay.append(asset)
                }
            }
        case 3:
            self.assetsOnDisplay = []
            for asset in self.assets {
                if asset.total < 0 {
                    self.assetsOnDisplay.append(asset)
                }
            }
        case 4:
            self.assetsOnDisplay = []
            for asset in self.assets {
                if asset.total == 0 && !asset.fiat {
                    self.assetsOnDisplay.append(asset)
                }
            }
        default:
            return
        }
        self.assetSwitches.map({ (button) in
            if button.tag == sender.tag {
                button.setTitleColor(UIColor.white, for: .normal)
                button.backgroundColor = UIView.theBlue
            } else {
                button.setTitleColor(UIColor.lightGray, for: .normal)
                button.backgroundColor = UIColor.clear
            }
            
            
        })
        self.selectorViews.map({ (view) in
            if view.tag == sender.tag {
                view.isHidden = true
            } else {
                view.isHidden = true
            }
            
        })
        
        sender.setTitleColor(UIColor.white, for: .normal)
        self.assetsOnDisplay.sort(by: { $0.0.total > $0.1.total })
        self.assetTableView.reloadData()
        if self.assetTableView.contentSize.height > prevHeight {
            self.tableHeight.constant = assetTableView.contentSize.height
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
        
        
        
        
    }
    var tapToCloseGesture: UITapGestureRecognizer?
    @IBAction func menu() {
        
        self.performSegue(withIdentifier: "ShowAccount", sender: self)
        return
//        self.tabBarController?.selectedIndex = 1
        if self.navigationController?.navigationBar.layer.zPosition == -1 {
//            self.menuView.isHidden = true
            self.navigationController?.navigationBar.layer.zPosition = 0
            self.view.removeGestureRecognizer(self.tapToCloseGesture!)
            collapseMenu()
        } else {
            
//            self.menuView.isHidden = false
            
            expandMenu()
            
            self.navigationController?.navigationBar.layer.zPosition = -1
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.closeMenu(_:)))
            self.tapToCloseGesture = tapGesture
            self.view.addGestureRecognizer(tapGesture)
        }
        
        
        
    }
    func expandMenu() {
        var view = menuBarButton.customView!
        
        view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: 200.0, height: 44.0)
        
        view.backgroundColor = UIColor.groupTableViewBackground
        
        UIView.animate(withDuration: 19.0, animations: {
            self.menuBarButton.customView!.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: 200.0, height: 44.0)
//            self.menuBarButton.customView!.addInnerShadow(onSide: .all, shadowColor: .darkGray, shadowSize: 1.0, shadowOpacity: 0.5)
            let innerShadow: YIInnerShadowView = YIInnerShadowView(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
            innerShadow.layer.cornerRadius = 22
            innerShadow.cornerRadius = 22
            innerShadow.shadowRadius = 2
            innerShadow.shadowOpacity = 0.4
            innerShadow.shadowColor = UIColor.lightGray
            innerShadow.shadowMask = YIInnerShadowMaskAll
            innerShadow.tag = 11
//            self.menuBarButton.customView!.addSubview(innerShadow)
            self.menuBarButton.customView?.setNeedsLayout()
            self.menuBarButton.customView?.layoutIfNeeded()
            
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }, completion: { (f) in
            
        })
        
    }
    func collapseMenu() {
        var view = menuBarButton.customView!
        view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: 44.0, height: 44.0)
        view.backgroundColor = UIColor.white
        view.viewWithTag(11)?.removeFromSuperview()
        menuBarButton.customView = view
        
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    func closeMenu(_ sender: UITapGestureRecognizer) {
        self.view.removeGestureRecognizer(sender)
        if self.navigationController?.navigationBar.layer.zPosition == -1 {
            self.menu()
        }
        
        
    }
    @IBAction func switchToView(sender: UIButton) {
        self.tabBarController?.selectedIndex = sender.tag - 1
        self.menu()
    }
    
    
    
    
}

extension ShowPortfolioViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.assetsOnDisplay.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssetCell") as! AssetTableViewCell
//        cell.setCell(data: self.coinsOnDisplay[indexPath.row])
        let row = indexPath.row
        let asset = self.assetsOnDisplay[row]
        
        for (index, each) in self.assets.enumerated() {
            if each.coinName == asset.coinName {
                let color = self.colorsForAssets[index]
                if self.chartData.count <= indexPath.row {
                    cell.setCell(asset: self.assetsOnDisplay[indexPath.row], color: color, data: [])
                } else {
                    cell.setCell(asset: self.assetsOnDisplay[indexPath.row], color: color, data: self.chartData[indexPath.row])
                }
                
            }
        }
        
        
        return cell
    }
}
extension ShowPortfolioViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        if self.assetsOnDisplay[row].fiat  {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
//        print(PortfolioWorker.sharedInstance.portfolio.assets[row].coin.name)
        self.performSegue(withIdentifier: "ShowCoin", sender: tableView)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension ShowPortfolioViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let price = entry.y
        self.chartValueLabel.text = "$\(price)"
    }
}

