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
    lazy var authListener: AuthListenerProtocol = AuthListener(delegate: self)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        authListener.listenForAuthState()

        return true
    }
}

extension AppDelegate: AuthListenerDelegate {
    func userDidLogIn(_ listener: AuthListenerProtocol, uid: String) {
        print(uid)
    }

    func userDidLogOut(_ listener: AuthListenerProtocol) {
        let vc = LoginViewController.make()
        window?.rootViewController = vc
    }
}
