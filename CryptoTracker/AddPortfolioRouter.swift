//
//  AddPortfolioRouter.swift
//  CryptoTracker
//
//  Created by Zaizen Kaegyoshi on 11/3/17.
//  Copyright (c) 2017 zaizencorp. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol AddPortfolioRoutingLogic
{
  //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol AddPortfolioDataPassing
{
  var dataStore: AddPortfolioDataStore? { get }
}

class AddPortfolioRouter: NSObject, AddPortfolioRoutingLogic, AddPortfolioDataPassing
{
  weak var viewController: AddPortfolioViewController?
  var dataStore: AddPortfolioDataStore?
  
  // MARK: Routing
  
  //func routeToSomewhere(segue: UIStoryboardSegue?)
  //{
  //  if let segue = segue {
  //    let destinationVC = segue.destination as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //  } else {
  //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
  //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //    navigateToSomewhere(source: viewController!, destination: destinationVC)
  //  }
  //}

  // MARK: Navigation
  
  //func navigateToSomewhere(source: AddPortfolioViewController, destination: SomewhereViewController)
  //{
  //  source.show(destination, sender: nil)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: AddPortfolioDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}