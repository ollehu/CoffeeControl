//
//  AppDelegate.swift
//  Coffeecontrol
// 
//  Olle

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let navigationController = UINavigationController(rootViewController: ViewController())
        navigationController.navigationBar.translucent = false
        self.window?.rootViewController = navigationController
        
        self.window?.makeKeyAndVisible()
        return true
    }

}

