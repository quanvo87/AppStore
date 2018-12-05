//
//  AppDelegate.swift
//  AppStore
//
//  Created by Quan Vo on 12/4/18.
//  Copyright © 2018 Quan Vo. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private let factory = Factory()
    private lazy var authListener: AuthListening = AuthListener(delegate: self)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        authListener.listenForAuthState()

        return true
    }
}

extension AppDelegate: AuthListeningDelegate {
    func userDidLogIn(_ listener: AuthListening, uid: String) {
        window?.rootViewController = factory.makeTabBarController(uid: uid)
    }

    func userDidLogOut(_ listener: AuthListening) {
        window?.rootViewController = LoginViewController.make()
    }
}
