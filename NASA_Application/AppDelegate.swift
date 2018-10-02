//
//  AppDelegate.swift
//  NASA_Application
//
//  Created by Christopher Vensand on 7/21/18.
//  Copyright © 2018 Christopher Vensand. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //makes the window the size of the screen
        window = UIWindow(frame: UIScreen.main.bounds)
        
        //assigns ViewController to be the initial view controller
        window?.rootViewController = UINavigationController(rootViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        //presents the window
        window?.makeKeyAndVisible()
        
        //navigation bar settings
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        
        
        return true
    }

}

