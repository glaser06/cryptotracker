//
//  LoadingViewController.swift
//  CryptoTracker
//
//  Created by Zaizen Kaegyoshi on 10/29/17.
//  Copyright © 2017 zaizencorp. All rights reserved.
//

import UIKit
import Hero
import RealmSwift

class LoadingViewController: UIViewController {
    
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loadingLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navigationController?.clearShadow()
//        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.heroNavigationAnimationType = .none
        
//        self.loadingView.pieChart.heroID = "pieChart"
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.heroNavigationAnimationType = .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        self.loadingView.pieChart.heroID = "pieChart"
//        self.performSegue(withIdentifier: "Load", sender: self)
        
        if self.navigationController != nil {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowPortfolio") as! ShowPortfolioViewController
            let vc2 = self.storyboard?.instantiateViewController(withIdentifier: "ListPortfolios") as! ListPortfoliosViewController
            
            let v1 = vc.view
            let v2 = vc2.view
            DispatchQueue.main.async {
                print("what the hell")
                self.navigationController!.pushViewController(vc, animated: true)
                let stackCount = self.navigationController!.viewControllers.count
                let index = stackCount - 1
                self.navigationController?.viewControllers.insert(vc2, at: index)
            }
//            PortfolioWorker.sharedInstance.chartDataWaitGroup.notify(queue: DispatchQueue.main, execute: {
//                
//            })
        } else {
//            self.view.heroModifiers = [.translate(x: 0, y: -660, z: 0)]
//            self.loadingView.pieChart.heroModifiers = [.translate(x: 0, y: -660, z: 0)]
//            self.loadingLabel.heroModifiers = [.translate(x: 0, y: 200, z: 0)]
//            self.titleLabel.heroModifiers = [.translate(x: 0, y: -660, z: 0)]
            let realm: Realm = try! Realm()
            //        print(realm.objects(Pair.self).count)
            
            if realm.objects(Pair.self).count < 1000 {
                self.loadingLabel.text = "First time setting up... May take a few minutes"
            }
            PortfolioWorker.sharedInstance.allPricesWaitGroup.notify(queue: DispatchQueue.main, execute: {
                self.performSegue(withIdentifier: "Load", sender: self)
            })
            
        }
        
        
    }
    func animate() {
        self.loadingView.rotatePie(duration: 2.0)
        if self.navigationController == nil {
            self.loadingView.rotatePie(duration: 3.0)
        } else {
            self.loadingView.rotatePie(duration: 2.0)
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var shouldLoad: Bool = false
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        
        return shouldLoad
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? UITabBarController {

            (segue.destination as! UITabBarController).viewControllers?.map({ (v) -> Void in
                print((v as! UINavigationController).viewControllers.first!.view)
            })
            
            let vc = segue.destination  as! UITabBarController
            let vc1 = vc.viewControllers!.first as! UINavigationController
        } else {
//            let view = segue.destination.view
            
            
            
        }
        
        
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
