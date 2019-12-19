//
//  AppDelegate.swift
//  YourRoute
//
//  Created by Jeans on 11/25/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var storyboard: UIStoryboard!
    
    //Config Map Type here
    private var selectedMap: DataSourceType = .google

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let controller = storyboard.instantiateViewController(withIdentifier: "MainNavigationViewController") as? MainNavigationViewController else {
            fatalError()
        }
        controller.setDataSource(source: selectedMap)
        
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
        
        return true
    }
}

