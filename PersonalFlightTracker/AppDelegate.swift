//
//  AppDelegate.swift
//  PersonalFlightTracker
//
//  Created by Joan on 24/08/2020.
//  Copyright © 2020 Joan Cardona. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        let navigation = UINavigationController(rootViewController: MapViewController())
        window?.rootViewController = navigation
        return true
    }

}

