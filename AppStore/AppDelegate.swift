//
//  AppDelegate.swift
//  AppStore
//
//  Created by Abraham Gonzalez on 11/11/18.
//  Copyright © 2018 Abraham Gonzalez. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        // Tab Items
        let featuredAppsController = FeaturedAppsController(collectionViewLayout: layout)
        featuredAppsController.title = "Featured"
        featuredAppsController.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarItem.SystemItem.featured, tag: 0)
        
        let chartAppsController = FeaturedAppsController(collectionViewLayout: layout)
        chartAppsController.title = "Top Charts"
        chartAppsController.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarItem.SystemItem.mostViewed, tag: 1)
        
        let exploreAppsController = FeaturedAppsController(collectionViewLayout: layout)
        exploreAppsController.title = "Explore"
        exploreAppsController.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarItem.SystemItem.bookmarks, tag: 2)
        
        let searchAppsController = FeaturedAppsController(collectionViewLayout: layout)
        searchAppsController.title = "Search"
        searchAppsController.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarItem.SystemItem.search, tag: 3)
        
        let updatesAppsController = FeaturedAppsController(collectionViewLayout: layout)
        updatesAppsController.title = "Updates"
        updatesAppsController.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarItem.SystemItem.downloads, tag: 4)
        
        
        let controllers = [featuredAppsController, chartAppsController, exploreAppsController, searchAppsController, updatesAppsController]
        
        let tabBarController = UITabBarController()
        
        tabBarController.viewControllers = controllers.map{UINavigationController(rootViewController: $0)}
    
       // let navigationController = UINavigationController(rootViewController: featuredAppsController)

        window?.rootViewController = tabBarController
        
        
        return true
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

