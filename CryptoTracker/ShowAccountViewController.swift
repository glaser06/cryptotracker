//
//  ShowAccountViewController.swift
//  CryptoTracker
//
//  Created by Zaizen Kaegyoshi on 9/4/17.
//  Copyright (c) 2017 zaizencorp. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import YIInnerShadowView

protocol ShowAccountDisplayLogic: class
{
  func displaySomething(viewModel: ShowAccount.Something.ViewModel)
}

class ShowAccountViewController: UIViewController, ShowAccountDisplayLogic
{
  var interactor: ShowAccountBusinessLogic?
  var router: (NSObjectProtocol & ShowAccountRoutingLogic & ShowAccountDataPassing)?

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
    let interactor = ShowAccountInteractor()
    let presenter = ShowAccountPresenter()
    let router = ShowAccountRouter()
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
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    doSomething()
//    self.view.bringSubview(toFront: self.menuView)
    setupMenu()
  }
  
  // MARK: Do something
  
//    @IBOutlet weak var menuView: UIView!
//    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    @IBOutlet weak var topLeftButton: UIButton!
  
    @IBAction func back() {
        self.tabBarController?.selectedIndex = 0
    }
    @IBAction func clearPortfolio() {
        PortfolioWorker.sharedInstance.portfolio = Portfolio()
        do {
//            try PortfolioWorker.sharedInstance.savePortfolio()
        } catch {
            
        }
        
    }
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    func setupMenu() {
        //        self.menuView.isHidden = false
        //        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.menuView)
        //        self.navigationController?.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.menuView)
//        var view = menuBarButton.customView!
//        view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: 44, height: 44)
//        
//        view.layer.cornerRadius = 22.0
        self.topLeftButton.setImage(#imageLiteral(resourceName: "close-black"), for: .normal)
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
    }
    var tapToCloseGesture: UITapGestureRecognizer?
    @IBAction func menu() {
        self.dismiss(animated: true, completion: nil)
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
    
  func doSomething()
  {
    let request = ShowAccount.Something.Request()
    interactor?.doSomething(request: request)
  }
  
  func displaySomething(viewModel: ShowAccount.Something.ViewModel)
  {
    //nameTextField.text = viewModel.name
  }
}
