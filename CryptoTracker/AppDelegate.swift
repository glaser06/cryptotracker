//
//  AppDelegate.swift
//  CryptoTracker
//
//  Created by Zaizen Kaegyoshi on 8/22/17.
//  Copyright © 2017 zaizencorp. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 5,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 5) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
//        clearData()
        
        
        setup()
//        MarketWorker.sharedInstance.fetchAllExchangesAndPairs(completion: nil)
        
        PortfolioWorker.sharedInstance.setup()
        
        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        
//        (self.window?.rootViewController as! UITabBarController).viewControllers?.map({ (v) -> Void in
//            print((v as! UINavigationController).viewControllers.first!.view)
//        })
        return true
    }
    func setup() {
        let realm: Realm = try! Realm()
//        print(realm.objects(Pair.self).count)
        MarketWorker.sharedInstance.setup()
        if realm.objects(Pair.self).count < 1000 {
            let start = Date()
            MarketWorker.sharedInstance.retrieveCoins(completion: {
                DispatchQueue.global(qos: .background).async {
                    MarketWorker.sharedInstance.fetchAllExchangesAndPairs(completion: {
                        
                        let end = Date()
                        let interval = end.timeIntervalSince(start)
                        print("finished setup, took \(interval) seconds")
                    })
                }
                
            })
            MarketWorker.sharedInstance.fetchCoinIDs(completion: nil)
        } else {
            MarketWorker.sharedInstance.retrieveCoins(completion: nil)
        }
        
    }
    func clearData() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

