//
//  CoinWebsiteViewController.swift
//  CryptoTracker
//
//  Created by Zaizen Kaegyoshi on 10/29/17.
//  Copyright © 2017 zaizencorp. All rights reserved.
//

import UIKit
import WebKit

class CoinWebsiteViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!

    var url: String = "https://www.apple.com"
    
    @IBOutlet weak var subView: UIView!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: subView.frame, configuration: webConfiguration)
        subView.addSubview(webView)
        constrainView(view: webView, toView: subView)
        print(self.url)
        let myURL = URL(string: self.url)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        webView.allowsBackForwardNavigationGestures = true
        
        
        
        
//        view.addSubview(webView)
    }
    func constrainView(view:UIView, toView contentView:UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    override func viewWillAppear(_ animated: Bool) {
        
//        webView.uiDelegate = self
//        self.subView = webView
        
        
        
        
    }
    @IBAction func close () {
        self.dismiss(animated: true, completion: nil)
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
