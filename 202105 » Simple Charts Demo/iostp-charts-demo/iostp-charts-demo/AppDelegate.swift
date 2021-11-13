//
//  AppDelegate.swift
//  iostp-charts-demo
//
//  Created by Ting Yen Kuo on 2021/5/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let navigationController = UINavigationController(rootViewController: DemoListViewController())

        window = .init(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        return true
    }
}
