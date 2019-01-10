//
//  AppDelegate.swift
//  AppStore
//
//  Created by Quan Vo on 12/4/18.
//  Copyright © 2018 Quan Vo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let factory = Factory()
        window?.rootViewController = factory.makeTabBarController()

        return true
    }
}
