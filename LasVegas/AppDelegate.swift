//
//  AppDelegate.swift
//  LasVegas
//
//  Created by Tyrant on 2020/1/2.
//  Copyright © 2020 Tyrant. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var rootvc: RootViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GameControl.application(application, didFinishLaunchingWithOptions: launchOptions ?? [:])
        
        GameControl.genesis()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        rootvc = RootViewController()
        
        window?.rootViewController = rootvc
        
        window?.makeKeyAndVisible()
        
        GameControl.start()
        
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
        
        return true
    }

    var window: UIWindow?
        
    
    @objc func orientationChanged() {
        GameControl.statusBarOrientationChanged()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


extension AppDelegate {
    
    func applicationWillResignActive(_ application: UIApplication) {
        GameControl.applicationWillResignActive(application)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        GameControl.applicationDidBecomeActive(application)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        GameControl.applicationDidEnterBackground(application)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        GameControl.applicationWillEnterForeground(application)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        GameControl.applicationWillTerminate(application)
    }
    
}

